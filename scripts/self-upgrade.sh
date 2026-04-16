#!/data/data/com.termux/files/usr/bin/bash
# fr3k Termux self-upgrade — run periodically to keep everything fresh
set -euo pipefail

echo "[1/5] Updating Termux packages..."
pkg update -y && pkg upgrade -y

echo "[2/5] Updating pip packages..."
pip3 install --upgrade requests httpx beautifulsoup4 rich typer pygments feedparser prompt_toolkit jinja2 pyyaml toml aiofiles python-dotenv 2>/dev/null

echo "[3/5] Updating npm global packages..."
npm update -g 2>/dev/null

echo "[4/5] Updating tldr cache..."
tldr --update 2>/dev/null

echo "[5/5] Cleaning up..."
apt autoremove -y 2>/dev/null
apt clean 2>/dev/null

echo ""
echo "=== UPGRADE COMPLETE ==="
echo "Packages: $(pkg list-installed 2>/dev/null | wc -l)"
echo "Python: $(python3 --version)"
echo "Node: $(node --version)"
echo "Storage: $(duf 2>/dev/null | head -3)"
