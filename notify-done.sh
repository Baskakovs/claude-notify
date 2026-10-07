#!/usr/bin/env bash
# Claude Code hook: plays a sound and shows a notification when task is done

case "$(uname -s)" in
  Darwin)
    afplay /System/Library/Sounds/Hero.aiff &
    osascript -e "tell application \"$(basename "$TERM_PROGRAM" .app 2>/dev/null || echo Terminal)\" to display notification \"Claude Code has finished\" with title \"Claude Code\" subtitle \"Task complete\"" &
    ;;
  Linux)
    if command -v paplay &>/dev/null; then
      paplay /usr/share/sounds/freedesktop/stereo/complete.oga &
    elif command -v aplay &>/dev/null; then
      aplay /usr/share/sounds/sound-icons/glass-water.wav 2>/dev/null &
    fi
    if command -v notify-send &>/dev/null; then
      notify-send "Claude Code" "Task complete"
    fi
    ;;
  MINGW*|MSYS*|CYGWIN*)
    powershell.exe -NoProfile -Command "[System.Media.SystemSounds]::Asterisk.Play()" &
    powershell.exe -NoProfile -Command "New-BurntToastNotification -Text 'Claude Code','Task complete' -ErrorAction SilentlyContinue; if(\$?) {} else { [void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('Task complete','Claude Code') }" &
    ;;
esac
