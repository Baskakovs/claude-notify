#!/usr/bin/env bash
set -e

CLAUDE_DIR="$HOME/.claude"
SETTINGS="$CLAUDE_DIR/settings.json"

# Copy scripts
cp notify-question.sh notify-done.sh "$CLAUDE_DIR/"
chmod +x "$CLAUDE_DIR/notify-question.sh" "$CLAUDE_DIR/notify-done.sh"

# Merge hooks into existing settings.json
if [ -f "$SETTINGS" ]; then
  # Check if jq is available
  if ! command -v jq &>/dev/null; then
    echo "Error: jq is required to merge into existing settings.json"
    echo "Install it: brew install jq / apt install jq / choco install jq"
    exit 1
  fi

  # Merge hooks into existing settings
  HOOKS='{
    "hooks": {
      "PreToolUse": [
        {
          "matcher": "AskUserQuestion",
          "hooks": [
            {
              "type": "command",
              "command": "$HOME/.claude/notify-question.sh"
            }
          ]
        }
      ],
      "Stop": [
        {
          "matcher": "",
          "hooks": [
            {
              "type": "command",
              "command": "$HOME/.claude/notify-done.sh"
            }
          ]
        }
      ]
    }
  }'

  jq --argjson hooks "$(echo "$HOOKS" | jq '.hooks')" '.hooks = $hooks' "$SETTINGS" > "$SETTINGS.tmp"
  mv "$SETTINGS.tmp" "$SETTINGS"
  echo "Merged hooks into existing $SETTINGS"
else
  mkdir -p "$CLAUDE_DIR"
  cat > "$SETTINGS" << 'SETTINGSEOF'
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "AskUserQuestion",
        "hooks": [
          {
            "type": "command",
            "command": "$HOME/.claude/notify-question.sh"
          }
        ]
      }
    ],
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "$HOME/.claude/notify-done.sh"
          }
        ]
      }
    ]
  }
}
SETTINGSEOF
  echo "Created $SETTINGS"
fi

echo "Done! Restart Claude Code for hooks to take effect."
echo ""
echo "Platform notes:"
case "$(uname -s)" in
  Darwin)
    echo "  Ensure your terminal app has notifications enabled:"
    echo "  System Settings > Notifications > Terminal (or your terminal app)"
    ;;
  Linux)
    echo "  For notifications: apt install libnotify-bin"
    echo "  For sounds: PulseAudio (paplay) or ALSA (aplay) required"
    ;;
esac
