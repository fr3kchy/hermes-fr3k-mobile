---
name: aws-toolkit
description: AWS operations skill — S3, EC2, Lambda, and CloudWatch via boto3. Manage cloud infrastructure from the command line.
---
# AWS Toolkit

Control your AWS infrastructure from the command line. Manage S3 buckets and objects, start/stop EC2 instances, invoke Lambda functions, and monitor CloudWatch metrics and alarms — all via boto3 with standard AWS credential environment variables.

## Setup

```bash
export AWS_ACCESS_KEY_ID="AKIAxxxxxxxxxxxxxxxx"
export AWS_SECRET_ACCESS_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
export AWS_REGION="us-east-1"   # or your preferred region
```

Create an IAM user with appropriate permissions (S3, EC2, Lambda, CloudWatch) and generate access keys in the AWS Console.

## Commands / Usage

```bash
# ── S3 ──────────────────────────────────────────────────
# List all buckets
python3 scripts/aws_toolkit.py s3-list-buckets

# List objects in a bucket
python3 scripts/aws_toolkit.py s3-list-objects --bucket my-bucket
python3 scripts/aws_toolkit.py s3-list-objects --bucket my-bucket --prefix "uploads/"

# Upload a file
python3 scripts/aws_toolkit.py s3-upload --bucket my-bucket --file ./report.pdf
python3 scripts/aws_toolkit.py s3-upload --bucket my-bucket --file ./report.pdf --key "reports/2024/report.pdf"

# Download a file
python3 scripts/aws_toolkit.py s3-download --bucket my-bucket --key "reports/2024/report.pdf" --output ./report.pdf

# Delete an object
python3 scripts/aws_toolkit.py s3-delete --bucket my-bucket --key "old-file.txt"

# Generate a presigned URL (expires in 3600s by default)
python3 scripts/aws_toolkit.py s3-presign --bucket my-bucket --key "private/file.pdf"
python3 scripts/aws_toolkit.py s3-presign --bucket my-bucket --key "private/file.pdf" --expires 7200

# ── EC2 ─────────────────────────────────────────────────
# List all instances
python3 scripts/aws_toolkit.py ec2-list

# Filter by state
python3 scripts/aws_toolkit.py ec2-list --state running
python3 scripts/aws_toolkit.py ec2-list --state stopped

# Start an instance
python3 scripts/aws_toolkit.py ec2-start --instance-id "i-0abc123def456789"

# Stop an instance
python3 scripts/aws_toolkit.py ec2-stop --instance-id "i-0abc123def456789"

# Get instance status
python3 scripts/aws_toolkit.py ec2-status --instance-id "i-0abc123def456789"

# ── LAMBDA ──────────────────────────────────────────────
# List all functions
python3 scripts/aws_toolkit.py lambda-list

# Invoke a function synchronously
python3 scripts/aws_toolkit.py lambda-invoke --function my-function
python3 scripts/aws_toolkit.py lambda-invoke --function my-function --payload '{"key": "value"}'

# Get function logs (most recent)
python3 scripts/aws_toolkit.py lambda-logs --function my-function
python3 scripts/aws_toolkit.py lambda-logs --function my-function --limit 50

# ── CLOUDWATCH ──────────────────────────────────────────
# List all alarms
python3 scripts/aws_toolkit.py cw-list-alarms
python3 scripts/aws_toolkit.py cw-list-alarms --state ALARM

# Get metrics for a resource
python3 scripts/aws_toolkit.py cw-get-metrics --namespace AWS/EC2 --metric CPUUtilization --dimension "InstanceId=i-0abc123"
python3 scripts/aws_toolkit.py cw-get-metrics --namespace AWS/S3 --metric BucketSizeBytes --dimension "BucketName=my-bucket"

# Get metrics with custom time window (hours ago)
python3 scripts/aws_toolkit.py cw-get-metrics --namespace AWS/Lambda --metric Invocations --dimension "FunctionName=my-func" --hours 24
```

## Requirements

- Python 3.8+
- `boto3` (`pip install boto3`)
- Environment variables: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`
