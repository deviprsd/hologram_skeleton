#!/usr/bin/env bash
# Usage: scripts/check_pruned_mfa.sh
#
# Compiles the app, then looks for HologramSkeleton.PluginSource.validate/2 in the client bundle of
# each page. Both pages call function_exported?(source, :validate, 2) on a module held in state;
# the second one also holds a literal capture of the function (&PluginSource.validate/2).
set -euo pipefail
MIX_ENV=dev mix compile >/dev/null

bundle_for() { ls priv/static/hologram/page-HologramSkeleton."$1"-*.js | grep -v '\.map$' | head -1; }

for page in DynamicDispatchPage DynamicDispatchWorkaroundPage; do
  file=$(bundle_for "$page")
  if grep -q 'Elixir_HologramSkeleton_PluginSource\["validate/2"\]' "$file"; then
    echo "$page: validate/2 IS in the client bundle"
  else
    echo "$page: validate/2 is NOT in the client bundle (function_exported? is false in the browser)"
  fi
done
