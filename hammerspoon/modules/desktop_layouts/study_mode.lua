-- Study Mode Layout (Enhanced & Fixed)
-- File: ~/.hammerspoon/modules/desktop_layouts/study_mode.lua

local study_mode = {}

-- Enable Spotlight support for application name searches
hs.application.enableSpotlightForNameSearches(true)

-- Helper function to get or launch application
local function getOrLaunchApp(appName)
    local app = hs.application.find(appName)
    if not app then
        hs.application.launchOrFocus(appName)
        -- Wait for app to launch
        local maxWait = 50 -- 5 seconds max
        local count = 0
        while not app and count < maxWait do
            hs.timer.usleep(100000) -- 0.1 second
            app = hs.application.find(appName)
            count = count + 1
        end
    else
        -- App is already running, just bring it to front
        app:activate()
    end
    return app
end

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



-- Setup function for the study layout
function study_mode.setupStudyLayout()
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
    local browser = hs.application.find("LibreWolf")
    local kitty = hs.application.find("kitty")
    local logseq = hs.application.find("Logseq")
    
    -- Launch missing apps
    if not browser then
        hs.application.launchOrFocus("LibreWolf")
    end
    if not kitty then
        hs.application.launchOrFocus("kitty")
    end
    if not logseq then
        hs.application.launchOrFocus("Logseq")
    end
    
    -- Position Kitty
    hs.timer.doAfter(kitty and 0.2 or 1.5, function()
        local kittyApp = hs.application.find("kitty")
        positionWindow(kittyApp, rightUpperQuarter)
    end)
    
    -- Position Browser 
    hs.timer.doAfter(browser and 0.4 or 3.5, function()
        browser = hs.application.find("LibreWolf")
        positionWindow(browser, leftHalf)
    end)
    
    -- Position Logseq
    hs.timer.doAfter(logseq and 0.6 or 6, function()
        local logseqApp = hs.application.find("Logseq")
        positionWindow(logseqApp, rightLowerQuarter)
    end)
    
    -- Show notification
    hs.notify.new({
        title = "Study Mode",
        informativeText = "Layout activated",
        withdrawAfter = 2
    }):send()
end

-- Initialize the module (call this from init.lua)
function study_mode.init()
    -- Bind the hotkey: Shift + Option + S
    hs.hotkey.bind({"shift", "alt"}, "s", study_mode.setupStudyLayout)
end

-- Return the module
return study_mode
