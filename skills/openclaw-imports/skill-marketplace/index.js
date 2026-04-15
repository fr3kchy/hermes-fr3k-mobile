#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const SKILLS_DIR = path.join(process.env.HOME || '/home/openclaw', '.openclaw', 'workspace', 'skills');

class SkillMarketplace {
  async search(query) {
    try {
      const out = execSync('npx clawhub search ' + query, { timeout: 30000 });
      return out.toString();
    } catch (e) {
      return `Search error: ${e.message}`;
    }
  }

  installed() {
    if (!fs.existsSync(SKILLS_DIR)) return 'No skills directory';
    const dirs = fs.readdirSync(SKILLS_DIR).filter(d => {
      return fs.statSync(path.join(SKILLS_DIR, d)).isDirectory();
    });
    return dirs.length ? dirs.join('\n') : 'No skills installed';
  }

  async checkUpdates() {
    try {
      const out = execSync('npx clawhub sync', { timeout: 60000 });
      return out.toString().includes('up to date') ? 'All skills up to date' : 'Updates available';
    } catch (e) {
      return 'No updates check needed';
    }
  }

  async install(skillName) {
    try {
      execSync('npx clawhub install ' + skillName, { timeout: 120000 });
      return `Installed: ${skillName}`;
    } catch (e) {
      return `Install failed: ${e.message}`;
    }
  }

  info(skillName) {
    const mdPath = path.join(SKILLS_DIR, skillName, 'SKILL.md');
    if (fs.existsSync(mdPath)) {
      const md = fs.readFileSync(mdPath, 'utf8');
      const desc = md.split('\n').find(l => l.startsWith('# ')) || '';
      return `${desc}\nLocation: ${mdPath}`;
    }
    return `Skill not installed: ${skillName}`;
  }
}

const a = process.argv.slice(2), c = a[0], sm = new SkillMarketplace();

(async () => {
  let r;
  switch (c) {
    case 'search': r = await sm.search(a.slice(1).join(' ')); break;
    case 'installed': r = sm.installed(); break;
    case 'updates': r = await sm.checkUpdates(); break;
    case 'install': r = await sm.install(a[1]); break;
    case 'info': r = sm.info(a[1]); break;
    default:
      r = `Skill Marketplace CLI
search <query>   - Search skills
installed        - List installed
updates          - Check for updates
install <name>   - Install a skill
info <name>      - Skill details`;
  }
  console.log(r);
})();
