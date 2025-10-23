#!/usr/bin/env bash
set -euo pipefail

# Usage function
usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Toggle or set GitHub SSH configuration state.

OPTIONS:
    --default     Set to default state (don't toggle)
    --toggled     Set to toggled state (don't toggle)
    --help        Show this help message

If no options are provided, the script will toggle between states as before.

EOF
}

# Parse command line arguments
TARGET_STATE=""
while [[ $# -gt 0 ]]; do
    case $1 in
        --default)
            TARGET_STATE="default"
            shift
            ;;
        --toggled)
            TARGET_STATE="toggled"
            shift
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Files and constants
SSH_DIR="${HOME}/.ssh"
CONFIG="${SSH_DIR}/config"
STATE_FILE="${HOME}/.ssh/.github-ssh-toggle.state"
BACKUP="${SSH_DIR}/backup.config.$(date +%Y%m%d-%H%M%S)"
MARKER="# --- managed by github-ssh-toggle !! ALWAYS KEEP THIS BLOCK IN THE BOTTOM OF THE FILE !! ---"

# Resolve script directory to find .env next to the script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${SCRIPT_DIR}/.env"

mkdir -p "${HOME}/.ssh"
touch "$CONFIG"
cp -a "$CONFIG" "$BACKUP"
echo "Backup created: $BACKUP"

# Extract multiline quoted var from .env
extract_var() {
    # $1 = VAR_NAME
    awk -v var="$1" '
        BEGIN { FS="="; invar=0; val="" }
        {
            if (!invar) {
                if ($1 == var) {
                    line=$0
                    m = match(line, /=\"/)
                    if (m) {
                        invar=1
                        val = substr(line, RSTART+2)
                        if (val ~ /"$/) {
                            sub(/"$/, "", val)
                            print val
                            exit
                        } else {
                            val = val "\n"
                        }
                    }
                }
            } else {
                if ($0 ~ /"$/) {
                    line=$0
                    sub(/"$/, "", line)
                    val = val line
                    print val
                    exit
                } else {
                    val = val $0 "\n"
                }
            }
        }
    ' "$ENV_FILE"
}

# Load .env
if [[ ! -f "$ENV_FILE" ]]; then
    echo "Error: .env not found at ${ENV_FILE}"
    exit 1
fi

DEFAULT_CONTENT="$(extract_var SSH_TOGGLE_DEFAULT || true)"
TOGGLED_CONTENT="$(extract_var SSH_TOGGLE_TOGGLED || true)"

if [[ -z "$DEFAULT_CONTENT" || -z "$TOGGLED_CONTENT" ]]; then
    echo "Error: Could not load SSH_TOGGLE_DEFAULT and/or SSH_TOGGLE_TOGGLED from ${ENV_FILE}"
    exit 1
fi

# Decide next state
if [[ -n "$TARGET_STATE" ]]; then
    # Use explicitly requested state
    state="$TARGET_STATE"
else
    # Default behavior: toggle (only used when marker exists)
    state="default"
    if [[ -f "$STATE_FILE" ]]; then
        if [[ "$(cat "$STATE_FILE")" == "default" ]]; then
            state="toggled"
        fi
    fi
fi

has_marker=false
if grep -Fqx "$MARKER" "$CONFIG"; then
    has_marker=true
fi

if $has_marker; then
    echo "$state" > "$STATE_FILE"
    if [[ "$state" == "toggled" ]]; then
        new_block="$TOGGLED_CONTENT"
        if [[ -n "$TARGET_STATE" ]]; then
            echo "Marker found. Setting to TOGGLED state."
        else
            echo "Marker found. Switching to TOGGLED state."
        fi
    else
        new_block="$DEFAULT_CONTENT"
        if [[ -n "$TARGET_STATE" ]]; then
            echo "Marker found. Setting to DEFAULT state."
        else
            echo "Marker found. Switching to DEFAULT state."
        fi
    fi

    # Keep up to marker (inclusive), replace the rest
    head_until_marker="$(awk -v marker="$MARKER" '
        {
            print
            if ($0==marker) { exit }
        }
    ' "$CONFIG")"

    {
        printf "%s\n" "$head_until_marker"
        printf "%s\n" "$new_block"
    } > "$CONFIG"
else
    # First-run behavior: DO NOT delete anything. Append marker + DEFAULT only.
    echo "Marker not found. Appending marker and DEFAULT content without deleting existing lines."
    echo "default" > "$STATE_FILE"

    {
        # Keep existing file as-is (no trimming/deletions)
        cat "$CONFIG"
        printf "\n\n%s\n%s\n" "$MARKER" "$DEFAULT_CONTENT"
    } > "${CONFIG}.new"

    mv "${CONFIG}.new" "$CONFIG"
fi

echo "Updated ${CONFIG}"
if command -v diff >/dev/null 2>&1; then
    diff -u "$BACKUP" "$CONFIG" || true
fi

echo "Verify with:"
echo "    ssh -G github.com | grep -E 'host |hostname|identityfile'"
echo "    ssh -G <github-alias-1> | grep -E 'host |hostname|identityfile'"
echo "    ssh -G <github-alias-2> | grep -E 'host |hostname|identityfile'"
