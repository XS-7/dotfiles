-- half screen split
hs.hotkey.bind({ "option", "shift" }, "left", function()
	hs.window.focusedWindow():moveToUnit({ 0, 0, 0.5, 1 })
end)
hs.hotkey.bind({ "option", "shift" }, "right", function()
	hs.window.focusedWindow():moveToUnit({ 0.5, 0, 0.5, 1 })
end)
hs.hotkey.bind({ "option", "shift" }, "up", function()
	hs.window.focusedWindow():moveToUnit({ 0, 0, 1, 0.5 })
end)
hs.hotkey.bind({ "option", "shift" }, "down", function()
	hs.window.focusedWindow():moveToUnit({ 0, 0.5, 1, 0.5 })
end)

-- quarter screen split
-- layout: 
--         u i
--         j k
hs.hotkey.bind({ "option", "shift" }, "u", function()
	hs.window.focusedWindow():moveToUnit({ 0, 0, 0.5, 0.5 })
end)
hs.hotkey.bind({ "option", "shift" }, "k", function()
	hs.window.focusedWindow():moveToUnit({ 0.5, 0.5, 0.5, 0.5 })
end)
hs.hotkey.bind({ "option", "shift" }, "i", function()
	hs.window.focusedWindow():moveToUnit({ 0.5, 0, 0.5, 0.5 })
end)
hs.hotkey.bind({ "option", "shift" }, "j", function()
	hs.window.focusedWindow():moveToUnit({ 0, 0.5, 0.5, 0.5 })
end)

-- full screen
-- shortcut: option + shift + f
hs.hotkey.bind({ "alt", "shift" }, "f", function()
	hs.window.focusedWindow():moveToUnit({ 0, 0, 1, 1 })
end)

-- center screen
-- shortcut: option + shift + c
hs.hotkey.bind({ "alt", "shift" }, "c", function()
	hs.window.focusedWindow():centerOnScreen()
end)
