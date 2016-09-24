local Theme = require('theme')
local UI = require 'lib.UI'
local class = require "lib.middleclass"
Menu = class('Menu')

function Menu:initialize(x, y, w, h, inputList)
    UI.DefaultTheme = Theme
    local buttonHeight = 35
    local topMargin = buttonHeight
    self.focusIndex = 0
    self.choice = nil
    self.choiceIndex = nil
    
    self.main_frame = UI.Frame(x, y, w, #inputList*buttonHeight, {closeable = true, draggable = true, drag_margin = topMargin})
   
    
    self.inputList = inputList
    self.buttons = {}
    self.textareas = {}
    local curY = 0
    for i, object in ipairs(inputList) do 
      self.buttons[i] = UI.Button(0,curY,w,buttonHeight)
      self.textareas[i] = UI.Textarea(0, curY, w, buttonHeight, {text_margin = 1, editing_locked = true})
      local letter = string.char(96+i)
      self.textareas[i]:addText(letter.." - ".. (object.name or object) .."\n")
      self.main_frame:addElement(self.textareas[i])
      self.main_frame:addElement(self.buttons[i])
      curY = curY + buttonHeight
    end

end

function Menu:update(dt)
  self.main_frame:update(dt)
  self.main_frame.selected = true
 
      for i,button in ipairs(self.buttons) do
       self.textareas[i].selected = self.buttons[i].selected
      end
  --check the status of each button
  for i,button in ipairs(self.buttons) do
    if button.pressed then
      self.choice = self.inputList[i]
      self.choiceIndex = i
    end
  end
end


function Menu:draw()
    self.main_frame:draw()
end

function Menu:focusNext()
  self.main_frame.selected = true
  self.focusIndex = (self.focusIndex + 1) % #(self.buttons)
  self.main_frame:focusElement((1+self.focusIndex)*2)
end

function Menu:focusPrevious()
  self.main_frame.selected = true
  self.focusIndex = (self.focusIndex - 1) % #(self.buttons)
  self.main_frame:focusElement((1+self.focusIndex)*2)
end

function Menu:keypressed(key)
  if key == 'kp8' or key == 'up' then
    self:focusPrevious()
  elseif key == 'kp2' or key == 'down' then
    self:focusNext()
  elseif key == 'return' then
    self.buttons[self.focusIndex+1]:press()
  else
    local index = string.byte(key)-96
    if self.inputList[index] then
      self.buttons[index]:press()
    end
  end
end
return Menu
