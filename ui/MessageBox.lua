local Theme = require 'ui.theme'
local UI = require 'lib.UI'
local MessageBox = UI.Object:extend('MessageBox')

function MessageBox:new(x, y, w, h)
    UI.DefaultTheme = Theme
    self.frame = UI.Frame(x, y, w, h, 
        {draggable = true, 
        drag_margin = 20, 
        disable_directional_selection = true, 
        disable_tab_selection = true, 
        resizable = true,
        resize_corner = 'bottom-right'}
        )

    self.scrollarea = UI.Scrollarea(0, 0, w, h+64, 
        {scrollbar_button_extensions = {Theme.Button}, 
        area_width = w,
        area_height = h, 
        show_scrollbars = true,
        vertical_step = 16})
    self.frame:addElement(self.scrollarea)

    self.textarea = UI.Textarea(0, 0, w, h+64, 
        {text_margin = 5, editing_locked = true}
        )
    self.scrollarea:addElement(self.textarea)
end

function MessageBox:update(dt)
    self.frame:update(dt)
end

function MessageBox:draw()
    self.frame:draw()
end

return MessageBox
