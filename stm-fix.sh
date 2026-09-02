#!/usr/bin/env bash
# ============================================================================
# SteamTools — steamtools-moon auto-installer (Linux)
#
# One-liner install:
#   curl -fsSL https://www.steamtools.app/stm-fix.sh | bash
#
# What it does:
#   1. Downloads the latest steamtools-moon-linux.zip from SteamTools-Team/Config
#   2. Extracts it to a temporary directory
#   3. Runs setup.sh install (creates wrapper, desktop entries, etc.)
# ============================================================================
set -euo pipefail

CONFIG_REPO="SteamTools-Team/Config"
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

# ── Download & extract ─────────────────────────────────────────────────────
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

info "Downloading steamtools-moon-linux.zip..."
curl -fSL -o "$TMPDIR/steamtools-moon-linux.zip" "$ZIP_URL" \
    || error "Download failed. Check your connection or try again later."

info "Extracting..."
unzip -qo "$TMPDIR/steamtools-moon-linux.zip" -d "$TMPDIR/extracted" \
    || error "Failed to extract zip."

# ── Run setup.sh install ───────────────────────────────────────────────────
SETUP_DIR="$TMPDIR/extracted"
if [ -f "$SETUP_DIR/setup.sh" ]; then
    chmod +x "$SETUP_DIR/setup.sh"
    info "Running steamtools-moon installer..."
    bash "$SETUP_DIR/setup.sh" install
else
    error "setup.sh not found in the release archive."
fi
