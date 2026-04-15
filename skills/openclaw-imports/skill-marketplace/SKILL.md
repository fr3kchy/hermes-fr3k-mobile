# Skill Marketplace Skill

Discover, explore, and manage OpenClaw skills from the marketplace.

## Commands

### Search Skills
```
@skill-marketplace search <query>
```
Search available skills on ClawHub.

### List Installed Skills
```
@skill-marketplace installed
```
List all skills currently installed.

### Check for Updates
```
@skill-marketplace updates
```
Check if any installed skills have updates available.

### Install Skill
```
@skill-marketplace install <skill-name>
```
Install a new skill from the marketplace.

### Skill Info
```
@skill-marketplace info <skill-name>
```
Show detailed information about a skill.

## Configuration

```json
{
  "skills": {
    "skill-marketplace": {
      "enabled": true,
      "autoUpdate": true,
      "notifyOnUpdate": true
    }
  }
}
```

## Features

- **Search**: Find skills by keyword or category
- **Auto-Update**: Check and update skills automatically
- **Categories**: Browse by category (automation, productivity, etc.)
- **Ratings**: View community ratings
- **Dependencies**: Check skill dependencies before install
