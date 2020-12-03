# Session Time (WoW Addon)
Shows the current session's time played and provides stats regarding play time.

## Features:
- Current session's time.
- Minimap button to show/hide the main addon's frame.
- Sessions history (date and hour, time played, character).
- Play time stats.
- Last two points can display user data (default) or character-specific data.
- For sessions time (current and history), color is interpolated using time:
  - 0 seconds → Green 
  - 1 hour → Yellow
  - 2 hours → Red
- For stats time, color is interpolated using time:
  - 0 seconds → Green
  - 2 hours → Yellow
  - 3 hours → Red
- Being *Away*/*AFK* stops the session's time counter.

## Demo:
![Time Display](https://media.giphy.com/media/eRNDMuoIO26G22Rtyy/giphy.gif)  

## Future work:
- More stats.
- Fix for extreme cases.
- Characters' names matching with their class.
- Color interpolation modifiable by the user

## External URLs
[<img src="https://upload.wikimedia.org/wikipedia/en/b/bd/Curse%2C_Inc_Logo.png" alt="CurseForge" width=100>](https://www.curseforge.com/wow/addons/session-time)
[<img src="https://s.wowinterface.com/images/wowinterface.gif" alt="WoWInterface" width=120>](https://www.wowinterface.com/downloads/info25814-SessionTime.html)
