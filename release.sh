#!/usr/bin/env bash
set -euo pipefail

# usage: ./release.sh v1.3.9

if [[ $# -ne 1 || ! "$1" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "usage: $0 vX.Y.Z (example: $0 v1.3.9)" >&2
    exit 1
fi

TAG="$1"
VER="${TAG#v}"
EXPORTS="./PackItUp/Exports"
CHANGELOG="./PackItUp/Changelogs/${VER}.md"
MRPACK="${EXPORTS}/Creatine ${TAG}.mrpack"

# sanity checks
for cmd in packwiz git git-cliff PackItUp gh; do
    command -v "$cmd" >/dev/null || { echo "missing tool: $cmd" >&2; exit 1; }
done
[[ -f .env ]] || { echo "missing .env" >&2; exit 1; }
[[ -z "$(git status --porcelain)" ]] || { echo "working tree not clean, commit or stash first" >&2; exit 1; }
git rev-parse "$TAG" >/dev/null 2>&1 && { echo "tag $TAG already exists" >&2; exit 1; }

# 1. version.txt
echo "Creatine ${TAG}" > version.txt

# 2. pack.toml
sed -i -E "s/^version = \".*\"/version = \"${VER}\"/" pack.toml

# 3. refresh index
packwiz refresh -y

# 4. commit
git add -A
git commit -m "release: bump ver to ${TAG}"

# 5. changelog
mkdir -p "$(dirname "$CHANGELOG")"
git-cliff --unreleased --tag "$TAG" -o "$CHANGELOG"

# 6. env vars
set -a
source .env
set +a

# 7. export
PackItUp --export

# 8. upload
PackItUp --upload

# 9. discard .packwizignore changes
git checkout -- .packwizignore

# 10-12. curseforge exports
mkdir -p "$EXPORTS"
packwiz curseforge export -o "${EXPORTS}/Creatine-cf-${TAG}-both.zip"
packwiz curseforge export -s client -o "${EXPORTS}/Creatine-cf-${TAG}-client.zip"
packwiz curseforge export -s server -o "${EXPORTS}/Creatine-cf-${TAG}-server.zip"

[[ -f "$MRPACK" ]] || { echo "mrpack not found: $MRPACK" >&2; exit 1; }

# push the release commit so the tag points at it on the remote
git push

# 13. github release (creates the tag too)
gh release create "$TAG" \
    --target "$(git rev-parse HEAD)" \
    --title "$TAG" \
    --notes-file "$CHANGELOG" \
    "${EXPORTS}/Creatine-cf-${TAG}-both.zip" \
    "${EXPORTS}/Creatine-cf-${TAG}-client.zip" \
    "${EXPORTS}/Creatine-cf-${TAG}-server.zip" \
    "$MRPACK"

echo "released ${TAG} :3"
