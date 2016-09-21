local Theme = require('theme')
local UI = require 'lib.UI'

local Term = UI.Object:extend('Term')

function Term:new(x, y, w, h)
    UI.DefaultTheme = Theme
    self.main_frame = UI.Frame(x, y, w, h, {draggable = true, drag_margin = 20, disable_directional_selection = true, disable_tab_selection = true})
    self.scrollarea = UI.Scrollarea(0, 20, w, h, {scrollbar_button_extensions = {Theme.Button}, 
                                                            area_width = w - 15, area_height = h, show_scrollbars = true})
    self.scrollarea.vertical_scrolling = true
    self.main_frame:addElement(self.scrollarea)

    self.textarea = UI.Textarea(0, 0, w, h, {text_margin = 0, editing_locked = true})
    self.scrollarea:addElement(self.textarea)

    self.scrollarea.horizontal_scrolling = false
end

function Term:update(dt)
    self.main_frame:update(dt)
end

function Term:sendMessage(text)
  if #text > 0 then
    local chat_text = os.date("%H:%M") .. ': ' .. text .. '\n'
    self.textarea:addText(chat_text)

    -- Scrolling
    if self.textarea:getMaxLines()*self.textarea.font:getHeight() > self.scrollarea.area_height then
      self.scrollarea.vertical_scrolling = true
      self.scrollarea.h = self.textarea:getMaxLines()*self.textarea.font:getHeight() + 4*self.textarea.text_margin
      self.textarea.h = self.textarea:getMaxLines()*self.textarea.font:getHeight() + 4*self.textarea.text_margin
      self.scrollarea:scrollDown(500)
    end

  end
end


function Term:draw()
    self.main_frame:draw()
end

return Term
