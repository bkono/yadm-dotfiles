#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# run-sandboxed.sh — Launch a command inside a sandbox-exec profile
# Usage: run-sandboxed.sh [--workdir=/path] <command> [args...]
#
# Workdir resolution order:
#   1. Explicit --workdir=/path flag
#   2. git rev-parse --show-toplevel (if inside a git repo)
#   3. pwd -P (fallback to current directory)
#
# The script replaces __SAFEHOUSE_WORKDIR__ in the profile with the resolved
# workdir path and injects ancestor directory literals for readdir() access.
# ---------------------------------------------------------------------------

PROFILE="${HOME}/.config/sandbox-exec/agent.sb"
WORKDIR=""

# --- Parse --workdir flag ---------------------------------------------------
if [[ "${1:-}" == --workdir=* ]]; then
    WORKDIR="${1#--workdir=}"
    shift
fi

if [[ $# -eq 0 ]]; then
    echo "Usage: run-sandboxed.sh [--workdir=/path] <command> [args...]" >&2
    exit 1
fi

# --- Resolve effective workdir ----------------------------------------------
if [[ -z "$WORKDIR" ]]; then
    WORKDIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd -P)"
fi
WORKDIR="$(cd "$WORKDIR" && pwd -P)"

# --- Build ancestor literal rules -------------------------------------------
# Agents call readdir() on every ancestor of the working directory during
# startup. Using 'literal' (not 'subpath') grants listing without recursive
# read access to files or subdirectories.
build_ancestors() {
    local path="$1"
    local result=""
    result+=";; Generated ancestor directory literals for dynamic workdir: ${path}"
    result+=$'\n'"(allow file-read*"
    result+=$'\n'"    (literal \"/\")"

    local trimmed="${path#/}"
    local cur=""
    local IFS='/'
    local -a parts
    read -r -a parts <<< "$trimmed"
    for part in "${parts[@]}"; do
        [[ -z "$part" ]] && continue
        cur+="/${part}"
        result+=$'\n'"    (literal \"${cur}\")"
    done
    result+=$'\n'")"
    printf '%s' "$result"
}

ANCESTORS="$(build_ancestors "$WORKDIR")"

# --- Assemble final profile into temp file ----------------------------------
TMPFILE="$(mktemp "${TMPDIR:-/tmp}/sandbox-profile.XXXXXX")"
trap 'rm -f "$TMPFILE"' EXIT

# Process each line: inject ancestors before workdir block, replace tokens.
while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ "$line" == *"__WORKDIR_BLOCK_START__"* ]]; then
        printf '%s\n\n%s\n' "$ANCESTORS" "$line"
    else
        printf '%s\n' "${line//__SAFEHOUSE_WORKDIR__/$WORKDIR}"
    fi
done < "$PROFILE" > "$TMPFILE"

# --- Launch sandboxed process -----------------------------------------------
exec sandbox-exec -f "$TMPFILE" "$@"
