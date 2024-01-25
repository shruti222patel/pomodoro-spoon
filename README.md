# Pomodoro Spoon

This is a spoon for hammerspoon for adding a pomodoro timer that also turns on do not disturb.

1. Install [Hammerspoon](https://www.hammerspoon.org/)
2. Install the following shortcuts
   - https://www.icloud.com/shortcuts/2079eff1727142e98b12725552826b52
   - https://www.icloud.com/shortcuts/96c533185a5542b0aa89ec00ba614313
3. Git clone and rename the `Pomodoro` directory to `Pomodoro.spoon`
4. Double-click `Pomodoro.spoon`
5. Update your `~/.hammerspoon/init.lua`
   ```lua
    hs.loadSpoon("Pomodoro")

    spoon.Pomodoro:bindHotkeys({
        start = {{"cmd", "ctrl", "alt"}, "P"}
    })
   ```
