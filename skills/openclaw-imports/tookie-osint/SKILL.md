---
name: tookie-osint
description: Tookie-OSINT — Username OSINT scanner. Discovers user accounts across 1000+ websites similar to Sherlock. Use when you need to find all social accounts associated with a username for OSINT investigations.
---

# Tookie-OSINT Skill

## Overview

Tookie-OSINT is a username OSINT scanner that discovers user accounts across 1000+ websites. Similar to Sherlock but written from scratch for performance. Claims ~80% success rate finding accounts.

## Installation

The skill already includes the tool. Dependencies auto-installed:
- colorama, requests, selenium, webdriver-manager

## Usage

```bash
# Single username scan
python3 brib.py -u username

# Multiple usernames from file
python3 brib.py -U usernames.txt

# With threads (default 2)
python3 brib.py -u username -t 4

# Output formats
python3 brib.py -u username -o json
python3 brib.py -u username -o csv
python3 brib.py -u username -o txt

# Use web scraper (slower but more thorough)
python3 brib.py -u username -W

# With proxy
python3 brib.py -u username -p http://proxy:port
```

## Options

| Flag | Description |
|------|-------------|
| `-u USER` | Single username to scan |
| `-U USERFILE` | File with multiple usernames |
| `-t THREADS` | Thread count (default: 2) |
| `-d` | Debug mode |
| `-sk` | Skip random user agents |
| `-p PROXY` | Use proxy |
| `-W` | Enable web scraper |
| `-o FORMAT` | Output: txt, csv, json |
| `-D DELAY` | Delay between requests |

## Examples

```bash
# Scan for "fr3k"
python3 brib.py -u fr3k

# Scan with JSON output
python3 brib.py -u fr3k -o json -t 4
```

