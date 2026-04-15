#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');
const crypto = require('crypto');

const BACKUP_DIR = path.join(process.env.HOME || '/home/openclaw', 'openclaw-backups');
if (!fs.existsSync(BACKUP_DIR)) fs.mkdirSync(BACKUP_DIR, { recursive: true });

function encrypt(data, password) {
  const key = crypto.scryptSync(password, 'salt', 32);
  const iv = crypto.randomBytes(16);
  const cipher = crypto.createCipheriv('aes-256-cbc', key, iv);
  let encrypted = cipher.update(data, 'utf8', 'hex');
  encrypted += cipher.final('hex');
  return iv.toString('hex') + ':' + encrypted;
}

function decrypt(data, password) {
  const [ivHex, encrypted] = data.split(':');
  const iv = Buffer.from(ivHex, 'hex');
  const key = crypto.scryptSync(password, 'salt', 32);
  const decipher = crypto.createDecipheriv('aes-256-cbc', key, iv);
  let decrypted = decipher.update(encrypted, 'hex', 'utf8');
  decrypted += decipher.final('utf8');
  return decrypted;
}

class EnhancedBackup {
  createBackup(o = {}) {
    const ts = new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19);
    const name = `openclaw-backup-${ts}`;
    const tmpPath = `/tmp/${name}.tar.gz`;
    try {
      let cmd = `openclaw backup create --output "${tmpPath}"`;
      if (o.configOnly) cmd += ' --only-config';
      if (o.noWorkspace) cmd += ' --no-include-workspace';
      if (o.verify) cmd += ' --verify';
      execSync(cmd, { stdio: 'ignore' });
      const outputPath = path.join(BACKUP_DIR, `${name}.tar.gz`);
      fs.renameSync(tmpPath, outputPath);
      if (o.encrypted && o.password) {
        const data = fs.readFileSync(outputPath);
        const enc = encrypt(data.toString('base64'), o.password);
        const ep = outputPath.replace('.tar.gz', '.enc');
        fs.writeFileSync(ep, enc); fs.unlinkSync(outputPath);
        return `Encrypted: ${ep}`;
      }
      return `Backup: ${outputPath}`;
    } catch (e) { return `Error: ${e.message}`; }
  }

  restore(backupPath, o = {}) {
    try {
      let restorePath = backupPath;
      if (backupPath.endsWith('.enc') && o.password) {
        const encData = fs.readFileSync(backupPath, 'utf8');
        const decrypted = decrypt(encData, o.password);
        const decPath = backupPath.replace('.enc', '.tar.gz');
        fs.writeFileSync(decPath, Buffer.from(decrypted, 'base64'));
        restorePath = decPath;
      }
      execSync(`tar -xzf "${restorePath}" -C ${process.env.HOME}/.openclaw`, { stdio: 'ignore' });
      return `Restored from: ${backupPath}`;
    } catch (e) { return `Restore error: ${e.message}`; }
  }

  list() {
    if (!fs.existsSync(BACKUP_DIR)) return 'No backups';
    return fs.readdirSync(BACKUP_DIR).sort().reverse().join('\n') || 'None';
  }
}

const a = process.argv.slice(2), c = a[0], b = new EnhancedBackup();
console.log(
  c === 'list' ? b.list() :
  c === 'create' ? b.createBackup({ configOnly: a.includes('--config-only'), noWorkspace: a.includes('--no-workspace'), verify: a.includes('--verify'), encrypted: a.includes('--encrypted') }) :
  c === 'restore' ? b.restore(a[1], { password: a.find(x => x.startsWith('--password='))?.split('=')[1] }) :
  'Usage: create [--config-only]|restore <path> [--password=]|list'
);
