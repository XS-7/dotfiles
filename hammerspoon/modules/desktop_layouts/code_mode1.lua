-- Code Mode 1 Layout (Properly Researched)
-- File: ~/.hammerspoon/modules/desktop_layouts/code_mode1.lua

local code_mode1 = {}

-- Helper function to position window with proper nil checks
local function positionWindow(app, frame)
    if not app then
        return false
    end
    
    local window = app:mainWindow()
    if not window then
        return false
    end
    
    window:setFrame(frame)
    window:raise()
    window:focus()
    return true
end

-- Helper function to wait for application to be ready
local function waitForApp(appName, callback, maxAttempts)
    maxAttempts = maxAttempts or 10
    local attempts = 0
    
    local function checkApp()
        attempts = attempts + 1
        -- hs.application.find returns multiple values or nil
        local app = hs.application.find(appName)
        
        if app then
            local window = app:mainWindow()
            if window then
                callback(app)
                return
            end
        end
        
        if attempts < maxAttempts then
            hs.timer.doAfter(0.5, checkApp)
        else
            hs.notify.new({
                title = "Code Mode 1",
                informativeText = "Failed to find " .. appName .. " after launch",
                withdrawAfter = 3
            }):send()
        end
    end
    
    checkApp()
end

-- Setup function for the code mode 1 layout
function code_mode1.setupCodeMode1Layout()
    -- Get the primary screen
    local screen = hs.screen.primaryScreen()
    if not screen then
        hs.notify.new({
            title = "Code Mode 1",
            informativeText = "No primary screen found",
            withdrawAfter = 3
        }):send()
        return
    end
    
    local screenFrame = screen:frame()
    
    -- Check if Kitty is already running with proper nil checks
    -- hs.application.find can return nil or multiple values
    local kitty = hs.application.find("kitty")
    local wasRunning = false
    
    if kitty then
        local window = kitty:mainWindow()
        wasRunning = window ~= nil
    end
    
    if wasRunning then
        -- Kitty is already running, configure it immediately
        if positionWindow(kitty, screenFrame) then
            -- Configure windows/panes - Based on Kitty docs, use Ctrl+Shift+Enter to create new window
            local windows = kitty:allWindows()
            if windows and #windows > 0 then
                windows[1]:focus()
                
                hs.timer.doAfter(0.1, function()
                    -- Create first new window (Kitty calls split panes "windows")
                    -- Default shortcut is Ctrl+Shift+Enter
                    hs.eventtap.keyStroke({"ctrl", "shift"}, "return")
                    hs.timer.doAfter(0.1, function()
                        -- Create second new window
                        hs.eventtap.keyStroke({"ctrl", "shift"}, "return")
                        hs.timer.doAfter(0.1, function()
                            -- Switch to tall layout using Ctrl+Shift+L
                            hs.eventtap.keyStroke({"ctrl", "shift"}, "l")
                            hs.timer.doAfter(0.1, function()
                                -- Focus on the first pane using Ctrl+Shift+1
                                hs.eventtap.keyStroke({"ctrl", "shift"}, "1")
                            end)
                        end)
                    end)
                end)
            end
            
            -- Show notification
            hs.notify.new({
                title = "Code Mode 1",
                informativeText = "Kitty 3-window layout activated",
                withdrawAfter = 2
            }):send()
        else
            hs.notify.new({
                title = "Code Mode 1",
                informativeText = "Failed to position Kitty window",
                withdrawAfter = 3
            }):send()
        end
    else
        -- Launch Kitty and wait for it to be ready
        hs.application.launchOrFocus("kitty")
        
        waitForApp("kitty", function(app)
            if positionWindow(app, screenFrame) then
                -- Configure windows after positioning
                hs.timer.doAfter(0.5, function()
                    local windows = app:allWindows()
                    if windows and #windows > 0 then
                        windows[1]:focus()
                        
                        hs.timer.doAfter(0.1, function()
                            -- Create first new pane
                            hs.eventtap.keyStroke({"ctrl", "shift"}, "return")
                            hs.timer.doAfter(0.1, function()
                                -- Create second new pane
                                hs.eventtap.keyStroke({"ctrl", "shift"}, "return")
                                hs.timer.doAfter(0.1, function()
                                    -- Switch to tall layout using Ctrl+Shift+L
                                    hs.eventtap.keyStroke({"ctrl", "shift"}, "l")
                                    hs.timer.doAfter(0.1, function()
                                    -- Focus on the first pane using Ctrl+Shift+1
                                        hs.eventtap.keyStroke({"ctrl", "shift"}, "1")
                                    end)
                                end)
                            end)
                        end)
                    end
                end)
                
                -- Show notification
                hs.notify.new({
                    title = "Code Mode 1",
                    informativeText = "Kitty 3-window layout activated",
                    withdrawAfter = 2
                }):send()
            else
                hs.notify.new({
                    title = "Code Mode 1",
                    informativeText = "Failed to position Kitty window after launch",
                    withdrawAfter = 3
                }):send()
            end
        end)
    end
end

-- Initialize the module (call this from init.lua)
function code_mode1.init()
    -- Bind the hotkey: Shift + Option + 1
    hs.hotkey.bind({"shift", "alt"}, "1", code_mode1.setupCodeMode1Layout)
end

-- Return the module
return code_mode1
