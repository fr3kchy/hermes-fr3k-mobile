#!/usr/bin/env python3
"""AWS Toolkit CLI — S3, EC2, Lambda, CloudWatch."""

import os
import sys
import json
import argparse
from datetime import datetime, timezone, timedelta

try:
    import boto3
    from botocore.exceptions import ClientError, NoCredentialsError
except ImportError:
    print(json.dumps({"error": "boto3 not installed", "fix": "pip install boto3"}))
    sys.exit(1)


def get_session():
    key = os.environ.get("AWS_ACCESS_KEY_ID")
    secret = os.environ.get("AWS_SECRET_ACCESS_KEY")
    region = os.environ.get("AWS_REGION", "us-east-1")
    if not key or not secret:
        print(json.dumps({
            "error": "AWS credentials not set",
            "setup": "export AWS_ACCESS_KEY_ID=xxx AWS_SECRET_ACCESS_KEY=xxx AWS_REGION=us-east-1"
        }))
        sys.exit(1)
    return boto3.Session(
        aws_access_key_id=key,
        aws_secret_access_key=secret,
        region_name=region
    )


def client(service):
    return get_session().client(service)


def err(e):
    print(json.dumps({"error": str(e)}))
    sys.exit(1)


# ── S3 ──────────────────────────────────────────────────

def s3_list_buckets(args):
    try:
        r = client("s3").list_buckets()
        buckets = [{"name": b["Name"], "created": b["CreationDate"].isoformat()}
                   for b in r.get("Buckets", [])]
        print(json.dumps(buckets, indent=2))
    except Exception as e:
        err(e)


def s3_list_objects(args):
    try:
        s3 = client("s3")
        kwargs = {"Bucket": args.bucket, "MaxKeys": 100}
        if args.prefix:
            kwargs["Prefix"] = args.prefix
        r = s3.list_objects_v2(**kwargs)
        objects = [{"key": o["Key"], "size": o["Size"], "last_modified": o["LastModified"].isoformat()}
                   for o in r.get("Contents", [])]
        print(json.dumps({"bucket": args.bucket, "count": len(objects), "objects": objects}, indent=2))
    except Exception as e:
        err(e)


def s3_upload(args):
    try:
        s3 = client("s3")
        key = args.key or os.path.basename(args.file)
        s3.upload_file(args.file, args.bucket, key)
        print(json.dumps({"uploaded": key, "bucket": args.bucket, "local": args.file}))
    except Exception as e:
        err(e)


def s3_download(args):
    try:
        output = args.output or os.path.basename(args.key)
        client("s3").download_file(args.bucket, args.key, output)
        print(json.dumps({"downloaded": args.key, "saved_to": output}))
    except Exception as e:
        err(e)


def s3_delete(args):
    try:
        client("s3").delete_object(Bucket=args.bucket, Key=args.key)
        print(json.dumps({"deleted": args.key, "bucket": args.bucket}))
    except Exception as e:
        err(e)


def s3_presign(args):
    try:
        url = client("s3").generate_presigned_url(
            "get_object",
            Params={"Bucket": args.bucket, "Key": args.key},
            ExpiresIn=args.expires
        )
        print(json.dumps({"url": url, "expires_in": args.expires, "key": args.key}))
    except Exception as e:
        err(e)


# ── EC2 ─────────────────────────────────────────────────

def ec2_list(args):
    try:
        ec2 = client("ec2")
        kwargs = {}
        if args.state:
            kwargs["Filters"] = [{"Name": "instance-state-name", "Values": [args.state]}]
        r = ec2.describe_instances(**kwargs)
        instances = []
        for res in r.get("Reservations", []):
            for i in res.get("Instances", []):
                name = ""
                for tag in i.get("Tags", []):
                    if tag["Key"] == "Name":
                        name = tag["Value"]
                instances.append({
                    "id": i["InstanceId"],
                    "name": name,
                    "type": i["InstanceType"],
                    "state": i["State"]["Name"],
                    "public_ip": i.get("PublicIpAddress"),
                    "private_ip": i.get("PrivateIpAddress"),
                    "launch_time": i["LaunchTime"].isoformat()
                })
        print(json.dumps(instances, indent=2))
    except Exception as e:
        err(e)


def ec2_start(args):
    try:
        r = client("ec2").start_instances(InstanceIds=[args.instance_id])
        state = r["StartingInstances"][0]
        print(json.dumps({
            "instance_id": args.instance_id,
            "previous_state": state["PreviousState"]["Name"],
            "current_state": state["CurrentState"]["Name"]
        }))
    except Exception as e:
        err(e)


def ec2_stop(args):
    try:
        r = client("ec2").stop_instances(InstanceIds=[args.instance_id])
        state = r["StoppingInstances"][0]
        print(json.dumps({
            "instance_id": args.instance_id,
            "previous_state": state["PreviousState"]["Name"],
            "current_state": state["CurrentState"]["Name"]
        }))
    except Exception as e:
        err(e)


def ec2_status(args):
    try:
        r = client("ec2").describe_instance_status(
            InstanceIds=[args.instance_id], IncludeAllInstances=True
        )
        statuses = r.get("InstanceStatuses", [])
        if not statuses:
            print(json.dumps({"error": "Instance not found"}))
            return
        s = statuses[0]
        print(json.dumps({
            "instance_id": s["InstanceId"],
            "state": s["InstanceState"]["Name"],
            "system_status": s["SystemStatus"]["Status"],
            "instance_status": s["InstanceStatus"]["Status"],
            "availability_zone": s["AvailabilityZone"]
        }, indent=2))
    except Exception as e:
        err(e)


# ── LAMBDA ──────────────────────────────────────────────

def lambda_list(args):
    try:
        lam = client("lambda")
        r = lam.list_functions(MaxItems=50)
        funcs = [{
            "name": f["FunctionName"],
            "runtime": f.get("Runtime"),
            "memory": f.get("MemorySize"),
            "timeout": f.get("Timeout"),
            "last_modified": f.get("LastModified"),
            "description": f.get("Description", "")[:80]
        } for f in r.get("Functions", [])]
        print(json.dumps(funcs, indent=2))
    except Exception as e:
        err(e)


def lambda_invoke(args):
    try:
        import base64
        lam = client("lambda")
        kwargs = {
            "FunctionName": args.function,
            "InvocationType": "RequestResponse",
            "LogType": "Tail"
        }
        if args.payload:
            kwargs["Payload"] = args.payload.encode()
        r = lam.invoke(**kwargs)
        payload = r["Payload"].read().decode()
        log_tail = ""
        if "LogResult" in r:
            import base64
            log_tail = base64.b64decode(r["LogResult"]).decode()[-500:]
        print(json.dumps({
            "status_code": r["StatusCode"],
            "function": args.function,
            "response": json.loads(payload) if payload else None,
            "log_tail": log_tail
        }, indent=2))
    except Exception as e:
        err(e)


def lambda_logs(args):
    try:
        import base64
        logs = client("logs")
        log_group = f"/aws/lambda/{args.function}"
        # Get latest log stream
        streams = logs.describe_log_streams(
            logGroupName=log_group, orderBy="LastEventTime",
            descending=True, limit=1
        )
        if not streams["logStreams"]:
            print(json.dumps({"message": "No log streams found"}))
            return
        stream = streams["logStreams"][0]["logStreamName"]
        events = logs.get_log_events(
            logGroupName=log_group, logStreamName=stream,
            limit=args.limit, startFromHead=False
        )
        log_lines = [{"timestamp": e["timestamp"], "message": e["message"].strip()}
                     for e in events.get("events", [])]
        print(json.dumps({"function": args.function, "stream": stream, "events": log_lines}, indent=2))
    except Exception as e:
        err(e)


# ── CLOUDWATCH ──────────────────────────────────────────

def cw_list_alarms(args):
    try:
        cw = client("cloudwatch")
        kwargs = {}
        if args.state:
            kwargs["StateValue"] = args.state
        r = cw.describe_alarms(**kwargs)
        alarms = [{
            "name": a["AlarmName"],
            "state": a["StateValue"],
            "metric": a.get("MetricName"),
            "namespace": a.get("Namespace"),
            "threshold": a.get("Threshold"),
            "comparison": a.get("ComparisonOperator"),
            "reason": a.get("StateReason", "")[:100]
        } for a in r.get("MetricAlarms", [])]
        print(json.dumps(alarms, indent=2))
    except Exception as e:
        err(e)


def cw_get_metrics(args):
    try:
        cw = client("cloudwatch")
        end = datetime.now(timezone.utc)
        start = end - timedelta(hours=args.hours)
        dimensions = []
        if args.dimension:
            for dim in args.dimension.split(","):
                k, v = dim.strip().split("=")
                dimensions.append({"Name": k.strip(), "Value": v.strip()})
        r = cw.get_metric_statistics(
            Namespace=args.namespace,
            MetricName=args.metric,
            Dimensions=dimensions,
            StartTime=start,
            EndTime=end,
            Period=3600,
            Statistics=["Average", "Sum", "Maximum", "Minimum"]
        )
        datapoints = sorted([{
            "timestamp": dp["Timestamp"].isoformat(),
            "average": dp.get("Average"),
            "sum": dp.get("Sum"),
            "maximum": dp.get("Maximum"),
            "minimum": dp.get("Minimum"),
            "unit": dp.get("Unit")
        } for dp in r.get("Datapoints", [])], key=lambda x: x["timestamp"])
        print(json.dumps({
            "namespace": args.namespace,
            "metric": args.metric,
            "hours": args.hours,
            "datapoints": datapoints
        }, indent=2))
    except Exception as e:
        err(e)


# ── CLI ─────────────────────────────────────────────────

def main():
    p = argparse.ArgumentParser(description="AWS Toolkit CLI")
    sub = p.add_subparsers(dest="cmd")

    # s3
    sub.add_parser("s3-list-buckets")

    slo = sub.add_parser("s3-list-objects")
    slo.add_argument("--bucket", required=True)
    slo.add_argument("--prefix")

    su = sub.add_parser("s3-upload")
    su.add_argument("--bucket", required=True)
    su.add_argument("--file", required=True)
    su.add_argument("--key")

    sd = sub.add_parser("s3-download")
    sd.add_argument("--bucket", required=True)
    sd.add_argument("--key", required=True)
    sd.add_argument("--output")

    sdel = sub.add_parser("s3-delete")
    sdel.add_argument("--bucket", required=True)
    sdel.add_argument("--key", required=True)

    sp = sub.add_parser("s3-presign")
    sp.add_argument("--bucket", required=True)
    sp.add_argument("--key", required=True)
    sp.add_argument("--expires", type=int, default=3600)

    # ec2
    ecl = sub.add_parser("ec2-list")
    ecl.add_argument("--state")

    ecs = sub.add_parser("ec2-start")
    ecs.add_argument("--instance-id", required=True, dest="instance_id")

    ecst = sub.add_parser("ec2-stop")
    ecst.add_argument("--instance-id", required=True, dest="instance_id")

    ecsta = sub.add_parser("ec2-status")
    ecsta.add_argument("--instance-id", required=True, dest="instance_id")

    # lambda
    sub.add_parser("lambda-list")

    li = sub.add_parser("lambda-invoke")
    li.add_argument("--function", required=True)
    li.add_argument("--payload")

    ll = sub.add_parser("lambda-logs")
    ll.add_argument("--function", required=True)
    ll.add_argument("--limit", type=int, default=25)

    # cloudwatch
    cwa = sub.add_parser("cw-list-alarms")
    cwa.add_argument("--state", choices=["OK", "ALARM", "INSUFFICIENT_DATA"])

    cwm = sub.add_parser("cw-get-metrics")
    cwm.add_argument("--namespace", required=True)
    cwm.add_argument("--metric", required=True)
    cwm.add_argument("--dimension")
    cwm.add_argument("--hours", type=int, default=24)

    args = p.parse_args()
    dispatch = {
        "s3-list-buckets": s3_list_buckets, "s3-list-objects": s3_list_objects,
        "s3-upload": s3_upload, "s3-download": s3_download,
        "s3-delete": s3_delete, "s3-presign": s3_presign,
        "ec2-list": ec2_list, "ec2-start": ec2_start,
        "ec2-stop": ec2_stop, "ec2-status": ec2_status,
        "lambda-list": lambda_list, "lambda-invoke": lambda_invoke, "lambda-logs": lambda_logs,
        "cw-list-alarms": cw_list_alarms, "cw-get-metrics": cw_get_metrics,
    }
    if args.cmd in dispatch:
        dispatch[args.cmd](args)
    else:
        p.print_help()


if __name__ == "__main__":
    main()
