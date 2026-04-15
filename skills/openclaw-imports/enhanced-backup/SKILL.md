# Enhanced Backup Skill

Extended backup capabilities with encryption and cloud storage targets.

## Commands

### Create Encrypted Backup
```
@enhanced-backup create-encrypted --password <secret>
```
Creates AES-256 encrypted backup archive.

### Cloud Backup (S3)
```
@enhanced-backup upload-s3 --bucket <bucket-name>
```
Uploads backup to AWS S3.

### Cloud Backup (GCS)
```
@enhanced-backup upload-gcs --bucket <bucket-name>
```
Uploads backup to Google Cloud Storage.

### Cloud Backup (R2)
```
@enhanced-backup upload-r2 --bucket <bucket-name>
```
Uploads backup to Cloudflare R2.

### List Backups
```
@enhanced-backup list
```
Lists all available backups (local + cloud).

### Restore from Backup
```
@enhanced-backup restore <backup-name> [--password <secret>]
```
Restores from a backup (decrypts if needed).

## Configuration

```json
{
  "skills": {
    "enhanced-backup": {
      "enabled": true,
      "encryptionKeyEnv": "BACKUP_ENCRYPTION_KEY",
      "cloudProviders": {
        "s3": { "region": "us-east-1" },
        "gcs": { "projectId": "my-project" },
        "r2": { "accountId": "my-account" }
      },
      "defaultTarget": "local"
    }
  }
}
```

## Features

- **AES-256 Encryption**: Secure backups with user-provided key
- **Multiple Cloud Targets**: S3, GCS, Cloudflare R2
- **Backup Verification**: Verify integrity before restore
- **Incremental Backups**: Only backup changed files
- **Compression**: gzip compression for storage efficiency
