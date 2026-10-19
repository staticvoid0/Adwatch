# Adwatch

A lightweight **Final Fantasy XI Windower addon** that monitors shout messages for user-defined keywords and phrases.

When a match is detected, Adwatch plays an audible alert, logs the full message with a timestamp, and displays a notification indicator in your chatlog.

## Features

- **Keyword Monitoring** — Watch for specific words or phrases in shout messages.
- **Audible Alerts** — Plays a sound when a match is detected.
- **Chatlog Notifications** — Marks matches with an indicator in your chatlog.
- **Timestamped Logging** — Records matching messages for later reference.
- **Persistent Watchlist** — Automatically saves your keywords between sessions.
- **Case-Insensitive Matching** — Matches keywords regardless of capitalization.

## Installation

1. Place the `Adwatch` folder in your Windower `addons` directory.
2. Load the addon in-game:

   ```text
   //lua load Adwatch
   ```

## Commands

| Command | Description |
|---|---|
| `//adwatch add <phrase>` | Add a keyword or phrase. |
| `//adwatch remove <phrase>` | Remove a keyword or phrase. |
| `//adwatch list` | Display all watched phrases. |
| `//adwatch` | Show command help. |

## Examples

```text
//adwatch add sortie
//adwatch add dynamis divergence
//adwatch add omen
//adwatch remove sortie
//adwatch list
```

**Note:** Multi-word phrases do not require quotation marks. Your watchlist is saved automatically whenever changes are made.

---

**Author:** Staticvoid  
**Platform:** Final Fantasy XI — Windower 4
