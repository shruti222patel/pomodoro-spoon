# Pomodoro Spoon

This is a spoon for hammerspoon for adding a pomodoro timer that also turns on do not disturb.

1. Install [Hammerspoon](https://www.hammerspoon.org/)
2. Install the following shortcuts
   - https://www.icloud.com/shortcuts/2ff807fd6a3b4fbe89dcc9d7bfe2bb95
   - https://www.icloud.com/shortcuts/8a1881ed69994cbca6e03a228d47ad85
3. Git clone and rename the `Pomodoro` directory to `Pomodoro.spoon`
4. Double-click `Pomodoro.spoon`
5. Update your `~/.hammerspoon/init.lua`
   ```lua
    hs.loadSpoon("Pomodoro")

    spoon.Pomodoro:bindHotkeys({
        start = {{"cmd", "ctrl", "alt"}, "P"}
    })
   ```
