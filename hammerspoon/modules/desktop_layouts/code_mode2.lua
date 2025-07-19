-- Code Mode 2 Layout (Enhanced)
-- File: ~/.hammerspoon/modules/desktop_layouts/code_mode2.lua

local code_mode2 = {}

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

-- Setup function for the code mode 2 layout
function code_mode2.setupCodeMode2Layout()
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
    
    local rightHalf = {
        x = screenFrame.x + screenFrame.w / 2,
        y = screenFrame.y,
        w = screenFrame.w / 2,
        h = screenFrame.h
    }

    -- Check for existing apps and launch if needed
    local zed = hs.application.find("Zed")
    local kitty = hs.application.find("kitty")
    
    -- Launch missing apps
    if not zed then
        hs.application.launchOrFocus("Zed")
    end
    if not kitty then
        hs.application.launchOrFocus("kitty")
    end
    
    -- Position Zed
    hs.timer.doAfter(zed and 0.2 or 1.5, function()
        zed = hs.application.find("Zed")
        positionWindow(zed, leftHalf)
    end)
    
    -- Position Kitty and configure panes
    hs.timer.doAfter(kitty and 0.4 or 2, function()
        kitty = hs.application.find("kitty")
        positionWindow(kitty, rightHalf)
        
        -- Configure panes after positioning
        hs.timer.doAfter(0.2, function()
            if kitty then
                local windows = kitty:allWindows()
                if windows and #windows > 0 then
                    windows[1]:focus()
                    
                    hs.timer.doAfter(0.1, function()
                        -- Create a new pane (split vertically)
                        hs.eventtap.keyStroke({"ctrl", "shift"}, "return")
                        
                        hs.timer.doAfter(0.2, function()
                            -- Focus on the first pane using Ctrl+Shift+1
                            hs.eventtap.keyStroke({"ctrl", "shift"}, "1")
                        end)
                    end)
                end
            end
        end)
    end)
    
    -- Show notification
    hs.notify.new({
        title = "Code Mode 2",
        informativeText = "Layout activated",
        withdrawAfter = 2
    }):send()
end

-- Initialize the module (call this from init.lua)
function code_mode2.init()
    -- Bind the hotkey: Shift + Option + 2
    hs.hotkey.bind({"shift", "alt"}, "2", code_mode2.setupCodeMode2Layout)
end

-- Return the module
return code_mode2