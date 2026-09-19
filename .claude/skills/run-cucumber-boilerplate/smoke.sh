#!/usr/bin/env bash
# Driver for the cucumber-boilerplate WebdriverIO+Cucumber suite.
# Runs headless (wdio.BUILD.conf.ts), no display/Xvfb required.
#
# Usage:
#   .claude/skills/run-cucumber-boilerplate/smoke.sh
#     -> runs the SauceDemo login + sort scenarios (default, fast, hits the real internet)
#   .claude/skills/run-cucumber-boilerplate/smoke.sh --all
#     -> runs the full src/features/**/*.feature suite (spins up the local demo-app too)
#   .claude/skills/run-cucumber-boilerplate/smoke.sh src/features/foo.feature [more.feature ...]
#     -> runs exactly the given feature file(s)
set -euo pipefail

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

if [ ! -d node_modules ]; then
  echo "== installing dependencies =="
  npm install
fi

# Kill any chromedriver/chrome left running from a previous interrupted run -
# stale processes on the same port make the next launch hang.
pkill -f "chromedriver" 2>/dev/null || true
pkill -f "Google Chrome for Testing" 2>/dev/null || true

if [ "${1:-}" = "--all" ]; then
  echo "== running full feature suite (demo-app + SauceDemo) =="
  exec npx wdio run wdio.BUILD.conf.ts
elif [ "$#" -gt 0 ]; then
  args=()
  for f in "$@"; do args+=(--spec "$f"); done
  echo "== running: $* =="
  exec npx wdio run wdio.BUILD.conf.ts "${args[@]}"
else
  echo "== running SauceDemo login + sort scenarios =="
  exec npx wdio run wdio.BUILD.conf.ts \
    --spec src/features/sauceDemoLogin.feature \
    --spec src/features/sauceDemoSort.feature
fi
