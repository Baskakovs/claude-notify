#!/usr/bin/env bash
# Claude Code hook: plays a sound when a question is asked

case "$(uname -s)" in
  Darwin)
    afplay /System/Library/Sounds/Submarine.aiff &
    ;;
  Linux)
    if command -v paplay &>/dev/null; then
      paplay /usr/share/sounds/freedesktop/stereo/message-new-instant.oga &
    elif command -v aplay &>/dev/null; then
      aplay /usr/share/sounds/sound-icons/prompt.wav 2>/dev/null &
    fi
    ;;
  MINGW*|MSYS*|CYGWIN*)
    powershell.exe -NoProfile -Command "[System.Media.SystemSounds]::Exclamation.Play()" &
    ;;
esac
