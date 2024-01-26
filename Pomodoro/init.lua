-- Pomodoro.spoon/init.lua
local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Pomodoro"
obj.version = "0.1"
obj.author = "Shruti Patel"
obj.license = "MIT"
obj.homepage = "https://github.com/Hammerspoon/Spoons"

-- Settings

-- Work and break durations in minutes (adjustable)
obj.workDuration = 25
obj.breakDuration = 5
obj.currentMode = "work" -- Can be "work" or "break"

-- Set this to true to always show the menubar item
obj.alwaysShow = true

-- Duration in seconds for alert to stay on screen
-- Set to 0 to turn off alert completely
obj.alertDuration = 3

-- Font size for alert
obj.alertTextSize = 80

-- Set to nil to turn off notification when time's up or provide a hs.notify notification
obj.notification = nil
-- obj.notification = hs.notify.new({ title = "Done! ☕", withdrawAfter = 0})

-- Set to nil to turn off notification sound when time's up or provide a hs.sound
obj.sound = nil
-- obj.sound = hs.sound.getByFile("System/Library/PrivateFrameworks/ScreenReader.framework/Versions/A/Resources/Sounds")

obj.defaultMapping = {
    start = {{"cmd", "ctrl", "alt"}, "P"}
}

-- Set to the name of the shortcut you created in the shortcuts app to turn on/off focus mode
obj.doNotDisturbOnShortcutName = "DoNotDisturbMe On"
obj.doNotDisturbOffShortcutName = "DoNotDisturbMe Off"

--- Pomodoro:bindHotkeys(mapping)
--- Method
--- Binds hotkeys for Pomodoro
---
--- Parameters:
---  * mapping - A table containing hotkey details for the following items:
---   * start - start the pomodoro timer (Default: cmd-ctrl-alt-C)
function obj:bindHotkeys(mapping)
    if (self.hotkey) then
        self.hotkey.delete()
    end

    if mapping and mapping["start"] then
        hs.hotkey.bind(mapping["start"][1], mapping["start"][2], function() self:start() end)
    elseif mapping and mapping["stop"] then
        hs.hotkey.bind(self.defaultMapping["stop"][1], self.defaultMapping["stop"][2], function() self:reset() end)
    else
        hs.hotkey.bind(self.defaultMapping["start"][1], self.defaultMapping["start"][2], function() self:start() end)
    end
end

function obj:init()
    self.menu = hs.menubar.new(self.alwaysShow)
    self:startWork() -- Set initial duration to work duration
    self:reset()
end

function obj:setDuration(minutes)
    self.timeLeft = minutes * 60
    self.duration = minutes -- Set duration in seconds
end

function obj:startWork()
    self:setDuration(self.workDuration)
    self.currentMode = "work"
    self:start(false)
    hs.shortcuts.run(self.doNotDisturbOnShortcutName)
end

function obj:startBreak()
    self:setDuration(self.breakDuration)
    self.currentMode = "break"
    self:start(false)
    hs.shortcuts.run(self.doNotDisturbOffShortcutName)
end

function obj:popup()
    if 0 < self.alertDuration then
        if self.currentMode == "work" then
            hs.alert.show("Focus time", { textSize = self.alertTextSize }, self.alertDuration)
        else
            hs.alert.show("Break time ☕", { textSize = self.alertTextSize }, self.alertDuration)
        end
        
    end
    if self.notification then
        self.notification:send()
    end
    if self.sound then
        self.sound:play()
    end
end

function obj:reset()
    local items = {
        { title = "Start", fn = function() self:start() end }
    }
    self.menu:setMenu(items)
    self.menu:setTitle("🍅")
    self.timerRunning = false
    if not self.alwaysShow then
        self.menu:removeFromMenuBar()
    end
end

function obj:updateTimerString()
    local minutes = math.floor(self.timeLeft / 60)
    local seconds = self.timeLeft - (minutes * 60)
    local timerString = ""
    if self.currentMode == "work" then
        timerString = string.format("%02d:%02d 🍅", minutes, seconds)
    else
        timerString = string.format("%02d:%02d ☕", minutes, seconds)
    end

    self.menu:setTitle(timerString)
end

function obj:tick()
    self.timeLeft = self.timeLeft - 1
    self:updateTimerString()
    if self.timeLeft <= 0 then
        if self.currentMode == "work" then
            self:startBreak()
        else
            self:startWork()
        end
        self:popup()
    end
end

--- Pomodoro:start()
--- Method
--- Starts the timer and displays the countdown in a menubar item
---
--- Parameters:
---  * resume - boolean when true resumes countdown at current value of self.timeLeft
---
--- Returns:
---  * None
function obj:start(resume)
    if not self.menu:isInMenuBar() then
        self.menu:returnToMenuBar()
        end
        if not resume then
            self:updateTimerString()
        end
        self.timerRunning = true
        self.timer = hs.timer.doWhile(function() return self.timerRunning end, function() self:tick() end, 1)
        local items = {
        { title = "Stop",  fn = function() self:reset() end },
        { title = "Pause", fn = function() self:pause() end }
        }
        self.menu:setMenu(items)
    end

function obj:pause()
    self.timerRunning = false
    local items = {
    { title = "Stop", fn = function() self:reset() end },
    { title = "Resume", fn = function() self:start(true) end }
    }
    self.menu:setMenu(items)
end

return obj