
-- Review Mode Layout
-- File: ~/.hammerspoon/modules/desktop_layouts/review_mode.lua

local review_mode = {}

-- Review Mode Layout (Enhanced)
-- File: ~/.hammerspoon/modules/desktop_layouts/review_mode.lua

local review_mode = {}

-- Helper function to position window
local function positionWindow(app, frame)
    if app then
        local window = app:mainWindow()
        if window then
            window:setFrame(frame)
            window:raise()
            window:focus()
        end
    end
end

-- Setup function for the review layout
function review_mode.setupReviewLayout()
    -- Get the primary screen
    local screen = hs.screen.primaryScreen()
    local screenFrame = screen:frame()
    
    -- Define positions
    local leftHalf = {
        x = screenFrame.x,
        y = screenFrame.y,
        w = screenFrame.w / 2,
        h = screenFrame.h
    }
    
    local rightUpperQuarter = {
        x = screenFrame.x + screenFrame.w / 2,
        y = screenFrame.y,
        w = screenFrame.w / 2,
        h = screenFrame.h / 2
    }
    
    local rightLowerQuarter = {
        x = screenFrame.x + screenFrame.w / 2,
        y = screenFrame.y + screenFrame.h / 2,
        w = screenFrame.w / 2,
        h = screenFrame.h / 2
    }
    
    -- Check for existing apps and launch if needed
    local anki = hs.application.find("Anki")
    local kitty = hs.application.find("kitty")
    local logseq = hs.application.find("Logseq")
    
    -- Launch missing apps
    if not anki then
        hs.application.launchOrFocus("Anki")
    end
    if not kitty then
        hs.application.launchOrFocus("kitty")
    end
    if not logseq then
        hs.application.launchOrFocus("Logseq")
    end
    
    -- Position Anki
    hs.timer.doAfter(anki and 0.4 or 2.5, function()
        anki = hs.application.find("Anki")
        positionWindow(anki, leftHalf)
    end)
    
    -- Position Kitty
    hs.timer.doAfter(kitty and 0.2 or 1.5, function()
        kitty = hs.application.find("kitty")
        positionWindow(kitty, rightUpperQuarter)
    end)
    
    -- Position Logseq
    hs.timer.doAfter(logseq and 0.6 or 6, function()
        logseq = hs.application.find("Logseq")
        positionWindow(logseq, rightLowerQuarter)
    end)
    
    -- Show notification
    hs.notify.new({
        title = "Review Mode",
        informativeText = "Layout activated",
        withdrawAfter = 2
    }):send()
end

-- Initialize the module (call this from init.lua)
function review_mode.init()
    -- Bind the hotkey: Shift + Option + R
    hs.hotkey.bind({"shift", "alt"}, "r", review_mode.setupReviewLayout)
end

-- Return the module
return review_mode
