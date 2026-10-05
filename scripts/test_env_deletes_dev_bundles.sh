#!/usr/bin/env bash
# Usage: scripts/test_env_deletes_dev_bundles.sh
#
# A :test compile and a :dev compile write their bundles to the same priv/static/hologram
# (priv/ is a symlink target shared by every build env), and after bundling each compile deletes
# whatever in that directory is not its own output. So `mix test` can delete the bundles a running
# dev server is serving.
set -euo pipefail
export HOLOGRAM_START=1
DIR=priv/static/hologram

rm -rf "$DIR"
MIX_ENV=dev mix compile --force >/dev/null 2>&1
dev_files=$(ls "$DIR" | grep -E '^(runtime|page)-.*\.js$' | sort)
echo "after MIX_ENV=dev compile:  $(echo "$dev_files" | wc -l | tr -d ' ') bundle files"

MIX_ENV=test mix compile --force >/dev/null 2>&1
test_files=$(ls "$DIR" | grep -E '^(runtime|page)-.*\.js$' | sort)
echo "after MIX_ENV=test compile: $(echo "$test_files" | wc -l | tr -d ' ') bundle files"

gone=$(comm -23 <(echo "$dev_files") <(echo "$test_files"))
if [ -n "$gone" ]; then
  echo "RESULT: the test compile deleted bundles the dev compile produced (bug):"
  echo "$gone" | sed 's/^/  /'
else
  echo "RESULT: every dev bundle survived the test compile (no bug)"
fi
