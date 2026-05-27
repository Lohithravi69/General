#!/bin/sh
set -eu

git config --global --add safe.directory /workspace
git config user.name "local-test"
git config user.email "local@test"

mkdir -p daily
date -u +"%Y-%m-%dT%H:%M:%SZ" > daily/file-one.txt
date -u +"%Y-%m-%dT%H:%M:%SZ" > daily/file-two.txt

git add daily/file-one.txt daily/file-two.txt
if git diff --cached --quiet; then
  echo "No staged changes"
else
  git commit -m "test: auto commit (local)"
fi

echo "Current HEAD:"
git rev-parse --short HEAD || true

git rm -f daily/file-one.txt daily/file-two.txt
if git diff --cached --quiet; then
  echo "No cleanup changes"
else
  git commit -m "test: cleanup (local)"
fi

echo "Cleanup HEAD:"
git rev-parse --short HEAD || true
