# Claude Code Notifications

Sound and desktop notification hooks for [Claude Code](https://claude.com/claude-code), so you don't have to keep watching the terminal.

- **Question asked** — distinct sound (Submarine on macOS) so you know input is needed
- **Task complete** — different sound (Hero on macOS) + desktop notification banner

Works on macOS, Linux, and Windows (WSL/Git Bash).

## Install

```bash
git clone https://github.com/Baskakovs/claude-notify.git
cd claude-notify
./install.sh
```

Then restart Claude Code.

## What it does

The install script copies two small shell scripts into `~/.claude/` and adds hooks to your `~/.claude/settings.json` (merging with existing settings if present).

| Hook | Event | macOS | Linux | Windows |
|---|---|---|---|---|
| `notify-question.sh` | Claude asks for input | Submarine sound | freedesktop sound | System exclamation |
| `notify-done.sh` | Claude finishes | Hero sound + banner | complete sound + notify-send | System asterisk + toast |

## Platform notes

### macOS
Ensure your terminal app has notifications enabled: **System Settings > Notifications > Terminal** (or whichever terminal you use).

### Linux
```bash
sudo apt install libnotify-bin    # for desktop notifications
# Sound requires PulseAudio (paplay) or ALSA (aplay)
```

### Windows
For toast notifications, install [BurntToast](https://github.com/Windos/BurntToast):
```powershell
Install-Module BurntToast
```

## Uninstall

Remove the `hooks` key from `~/.claude/settings.json` and delete the scripts:

```bash
rm ~/.claude/notify-question.sh ~/.claude/notify-done.sh
```
