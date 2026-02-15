#!/usr/bin/env bash
set -euo pipefail

# Build the forest
echo "Building forest..."
forester build forest.toml

# Deploy to gh-pages branch
cd output/forest
git init
git add -A
git commit -m "deploy"
git branch -M gh-pages
git remote add origin git@github.com:allenxch/forest.git
git push -f origin gh-pages

echo "Deployed to https://allenxch.github.io/forest/"
