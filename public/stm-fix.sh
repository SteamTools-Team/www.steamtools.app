#!/usr/bin/env bash
# ============================================================================
# SteamTools — steamtools-moon auto-installer (Linux)
#
# One-liner install:
#   curl -fsSL https://www.steamtools.app/stm-fix.sh | bash
#
# What it does:
#   1. Downloads steamtools-moon-linux.zip from SteamTools-Team/Config
#   2. Fetches helper libraries from SteamTools-Team/steamtools-moon
#   3. Prepares the source tree layout expected by setup.sh
#   4. Runs setup.sh install
# ============================================================================
set -euo pipefail

CONFIG_REPO="SteamTools-Team/Config"
MOON_REPO="SteamTools-Team/steamtools-moon"
MOON_BRANCH="slsteam-moon"
ZIP_URL="https://raw.githubusercontent.com/$CONFIG_REPO/main/steamtools-moon-linux.zip"

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()  { printf "${BOLD}${GREEN}✓${NC} %s\n" "$1"; }
warn()  { printf "${BOLD}${YELLOW}!${NC} %s\n" "$1"; }
error() { printf "${BOLD}${RED}✗${NC} %s\n" "$1" >&2; exit 1; }

command -v curl >/dev/null || error "curl is required. Install it with your package manager."
command -v unzip >/dev/null || error "unzip is required. Install it with your package manager."

# ── Download zip ───────────────────────────────────────────────────────────
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

info "Downloading steamtools-moon-linux.zip..."
curl -fSL -o "$TMPDIR/steamtools-moon-linux.zip" "$ZIP_URL" \
    || error "Download failed. Check your connection."

info "Extracting..."
unzip -qo "$TMPDIR/steamtools-moon-linux.zip" -d "$TMPDIR/root" \
    || error "Failed to extract zip."

# ── Prepare source tree layout ─────────────────────────────────────────────
# setup.sh expects: ./bin/SteamTools.so, ./tools/*.lib.sh, ./setup.sh, etc.
mkdir -p "$TMPDIR/root/bin" "$TMPDIR/root/tools"

mv "$TMPDIR/root/SteamTools.so" "$TMPDIR/root/bin/SteamTools.so"
[ -f "$TMPDIR/root/library-inject.so" ] && mv "$TMPDIR/root/library-inject.so" "$TMPDIR/root/bin/library-inject.so"

# Fetch helper libraries from the steamtools-moon repo
info "Fetching helper libraries..."
for f in desktop-coverage.lib.sh launcher-shim.lib.sh desktop-guardian-units.lib.sh; do
    curl -fsSL -o "$TMPDIR/root/tools/$f" \
        "https://raw.githubusercontent.com/$MOON_REPO/$MOON_BRANCH/tools/$f" \
        || warn "Could not fetch $f — some features may be unavailable"
done

# ── Run setup.sh install ───────────────────────────────────────────────────
SETUP="$TMPDIR/root/setup.sh"
if [ ! -f "$SETUP" ]; then
    error "setup.sh not found in the release archive."
fi

chmod +x "$SETUP"
info "Running steamtools-moon installer..."
cd "$TMPDIR/root"
exec bash "$SETUP" install
