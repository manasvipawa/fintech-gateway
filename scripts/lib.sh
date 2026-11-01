# Shared helpers for the demo scripts (sourced, not run directly)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# Print a section banner
banner() {
  printf '\n\033[1;35m==================== %s ====================\033[0m\n' "$*"
}

# Show the command (like a terminal prompt), then run it
run() {
  printf '\n\033[1;36m$ %s\033[0m\n' "$*"
  eval "$@"
}

ok() {
  printf '\n\033[1;32m✔ %s\033[0m\n' "$*"
}
