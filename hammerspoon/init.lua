require("modules.window_manager.config")
require("modules.window_manager.window")
require("modules.window_manager.slowQuit")

-- Load all desktop layout modules
local study_mode = require("modules.desktop_layouts.study_mode")
local review_mode = require("modules.desktop_layouts.review_mode")
local code_mode1 = require("modules.desktop_layouts.code_mode1")
local code_mode2 = require("modules.desktop_layouts.code_mode2")
-- Initialize all layout modules (this sets up the hotkeys)
study_mode.init()    -- Shift + Option + S
review_mode.init()   -- Shift + Option + R
code_mode1.init()    -- Shift + Option + 1
code_mode2.init()    -- Shift + Option + 2


hs.alert.show("Hammerspoon Config Reloaded")
