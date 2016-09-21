local Theme = require('theme')
local UI = require 'lib.UI'

local InvMenu = UI.Object:extend('InvMenu')


function InvMenu:new(x, y, w, h, invList)
    UI.DefaultTheme = Theme
    local buttonHeight = 35
    local topMargin = buttonHeight
    self.focusIndex = 0
    
    self.main_frame = UI.Frame(x, y, w, #invList*buttonHeight, {draggable = true, drag_margin = topMargin})
   
    
    self.invList = invList
    self.buttons = {}
    self.textareas = {}
    local curY = 0
    for i, invText in ipairs(invList) do 
      self.buttons[i] = UI.Button(0,curY,w,buttonHeight)
      self.textareas[i] = UI.Textarea(0, curY, w, buttonHeight, {text_margin = 1, editing_locked = true})
      local letter = string.char(96+i)
      self.textareas[i]:addText(letter.." - "..invText.."\n")
      self.main_frame:addElement(self.textareas[i])
      self.main_frame:addElement(self.buttons[i])
      curY = curY + buttonHeight
    end

end

function InvMenu:update(dt)
  self.main_frame:update(dt)
  if self.main_frame.pressed then
      for i,button in ipairs(self.buttons) do
        button.selected = false
      end
  end
  --check the status of each button
  for i,button in ipairs(self.buttons) do
    if button.released then
      message = self.invList[i]
    end
  end
end


function InvMenu:draw()
    self.main_frame:draw()
end

function InvMenu:focusNext()
  self.main_frame.selected = true
  self.focusIndex = (self.focusIndex + 1) % #(self.buttons)
  self.main_frame:focusElement((1+self.focusIndex)*2)
end

function InvMenu:focusPrevious()
  self.main_frame.selected = true
  self.focusIndex = (self.focusIndex - 1) % #(self.buttons)
  self.main_frame:focusElement((1+self.focusIndex)*2)
end

function InvMenu:keypressed(key)
  local index = string.byte(key)-96
  if self.invList[index] then
    self.buttons[index]:press()
    self.buttons[index].selected = false
  end
end

return InvMenu
