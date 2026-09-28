#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

echo "Fetching latest version..."
MANIFEST=$(curl -fsSL https://proton.me/download/pass-cli/versions.json)

VERSION=$(echo "$MANIFEST" | jq -r '.passCliVersions.version')
HASH_X86_64=$(echo "$MANIFEST" | jq -r '.passCliVersions.urls.linux.x86_64.hash')
HASH_AARCH64=$(echo "$MANIFEST" | jq -r '.passCliVersions.urls.linux.aarch64.hash')

CURRENT_VERSION=$(grep 'version = ' package.nix | sed 's/.*"\(.*\)".*/\1/')

if [ "$VERSION" = "$CURRENT_VERSION" ]; then
    echo "Already up to date: $VERSION"
    exit 0
fi

echo "Updating $CURRENT_VERSION → $VERSION"

sed -i "s/version = \".*\"/version = \"$VERSION\"/" package.nix
sed -i "/x86_64-linux = /s/sha256 = \"[^\"]*\"/sha256 = \"$HASH_X86_64\"/" package.nix
sed -i "/aarch64-linux = /s/sha256 = \"[^\"]*\"/sha256 = \"$HASH_AARCH64\"/" package.nix

echo "Updated to $VERSION"
echo ""
echo "Test with: nix build .#proton-pass-cli"
echo "Then commit: git add -A && git commit -m 'Update proton-pass-cli to $VERSION'"
