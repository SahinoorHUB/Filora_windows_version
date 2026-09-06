#!/usr/bin/env bash
# Publish filora_*.7z to GitHub Releases on Filora_windows_version.
set -euo pipefail

REPO="SahinoorHUB/Filora_windows_version"
VERSION="${1:-1.0.2}"
TAG="v${VERSION}"
ARCHIVE="filora_${VERSION}.7z"
NOTES="${2:-Share files from PC to phone, receive files from phone via QR scan.}"

if [[ ! -f "$ARCHIVE" ]]; then
  echo "Missing $ARCHIVE in $(pwd)" >&2
  exit 1
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "GitHub CLI (gh) is required. Install: brew install gh && gh auth login" >&2
  exit 1
fi

gh release view "$TAG" -R "$REPO" >/dev/null 2>&1 \
  && gh release upload "$TAG" "$ARCHIVE" --clobber -R "$REPO" \
  || gh release create "$TAG" "$ARCHIVE" \
       --title "Filora ${VERSION} (Windows)" \
       --notes "$NOTES" \
       -R "$REPO"

echo "Published: https://github.com/${REPO}/releases/download/${TAG}/${ARCHIVE}"
