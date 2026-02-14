#!/bin/bash
# Unified notification script for Claude Code hooks.
# Usage: bash ~/.claude/scripts/notify.sh --event <notification|stop>
#
# Auto-detects IDE/terminal environment and adds click-to-open action:
#   VSCode, Terminal.app

set -euo pipefail

# --- Parse arguments ---
EVENT=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --event) EVENT="$2"; shift 2 ;;
        *)       shift ;;
    esac
done

if [[ -z "$EVENT" ]]; then
    echo "Error: --event argument is required" >&2
    exit 1
fi

# --- Read hook input from stdin ---
INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty')

# Guard against recursive stop hooks
if [[ "$EVENT" = "stop" ]]; then
    STOP_HOOK_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // empty')
    if [[ "$STOP_HOOK_ACTIVE" = "true" ]]; then
        exit 0
    fi
fi

PROJECT_DIR="$PWD"
SESSION_SHORT="${SESSION_ID:0:8}"

# --- Gather project info ---
REPO_NAME=$(basename "$(git -C "$PROJECT_DIR" rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null || basename "$PROJECT_DIR")
BRANCH=$(git -C "$PROJECT_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")

# --- Determine message and sound by event type ---
case "$EVENT" in
    notification)
        TITLE="Claude Code - Attention"
        SOUND="Sosumi"
        ;;
    stop)
        TITLE="Claude Code - Complete"
        SOUND="default"
        ;;
    *)
        echo "Error: Unknown event type: $EVENT" >&2
        exit 1
        ;;
esac

# --- Build subtitle: git info or directory ---
if [[ -n "$BRANCH" ]]; then
    SUBTITLE="${REPO_NAME} @ ${BRANCH}"
else
    SUBTITLE="${PROJECT_DIR}"
fi
MESSAGE="Session: ${SESSION_SHORT}"

# --- Detect IDE/terminal environment ---
# Priority: VSCode (extension or terminal) > Terminal.app
detect_ide() {
    if [[ -n "${VSCODE_PID:-}" || "${TERM_PROGRAM:-}" = "vscode" ]]; then
        echo "vscode"
    elif [[ "${TERM_PROGRAM:-}" = "Apple_Terminal" ]]; then
        echo "terminal"
    else
        echo "unknown"
    fi
}

IDE=$(detect_ide)

# --- Build click action arguments for terminal-notifier ---
# Uses the most reliable option per IDE:
#   -open    : opens a URL/URI scheme (VSCode URI targets specific project window)
#   -activate: brings an app to foreground by Bundle ID (Terminal.app)
build_click_action() {
    local ide="$1"
    local dir="$2"

    case "$ide" in
        vscode)
            echo "-open"
            echo "vscode://file${dir}"
            ;;
        terminal)
            echo "-activate"
            echo "com.apple.Terminal"
            ;;
    esac
}

CLICK_ACTION=()
if [[ "$IDE" != "unknown" ]]; then
    mapfile -t CLICK_ACTION < <(build_click_action "$IDE" "$PROJECT_DIR")
fi

# --- Build terminal-notifier arguments ---
NOTIFY_ARGS=(
    -title "$TITLE"
    -subtitle "$SUBTITLE"
    -message "$MESSAGE"
    -sound "$SOUND"
    -group "claude-code-${SESSION_SHORT}"
    "${CLICK_ACTION[@]}"
)

# --- Send notification ---
terminal-notifier "${NOTIFY_ARGS[@]}"
