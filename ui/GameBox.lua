local Theme = require 'ui.theme'
local UI = require 'lib.UI'
local GameBox = UI.Object:extend('GameBox')

function GameBox:new(x, y, w, h)
    UI.DefaultTheme = Theme
    self.frame = UI.Frame(x, y, w, h, {draggable = true, drag_margin = 20, disable_directional_selection = true, disable_tab_selection = true})
end

function GameBox:update(dt)
    self.frame:update(dt)
end

function GameBox:draw()
    self.frame:draw()
end

return GameBox
