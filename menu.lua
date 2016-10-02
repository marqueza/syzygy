local Theme = require('theme')
local UI = require 'lib.UI'
local class = require "lib.middleclass"
Menu = class('Menu')

function Menu:initialize(x, y, inputList)
    
    UI.DefaultTheme = Theme
    local buttonHeight = 35
    local topMargin = buttonHeight
    self.focusIndex = 0
    self.choice = nil
    self.choiceIndex = nil
    self.pressedIndex = nil
    self.textList = {}
    self.dupList = {}
    self.outList = {}
    
    --store duplicates values in dupList
    for i,object in ipairs(inputList) do
      local text = object.name or object
      if not self.dupList[text] then
        self.dupList[text] = 1
      else
        self.dupList[text] = self.dupList[text] + 1
      end
    end
    --get a sorted indexed table 
    for item, value in pairs(self.dupList) do
     if value == 1 then 
        table.insert(self.outList, item)
        table.insert(self.textList, item)
      else
        table.insert(self.outList, item .. ' ' .. value)
        table.insert(self.textList, item)
      end
    end
    table.sort(self.textList)
    table.sort(self.outList)
    
    --determine width based on text
    --count the text for the bigger charCount
    --save the max charCount
    local charCount = 0
    for i,text in ipairs(self.outList) do
      charCount = math.max(charCount, string.len('A - '..text))
    end
    local w = charCount*17
    
    self.main_frame = UI.Frame(x, y, w, #self.outList*buttonHeight, {closeable = true, draggable = true, drag_margin = topMargin})
   
    
    self.inputList = inputList
    self.buttons = {}
    self.textareas = {}
    local curY = 0
    for i, text in ipairs(self.outList) do 
      self.buttons[i] = UI.Button(0,curY,w,buttonHeight)
      self.textareas[i] = UI.Textarea(0, curY, w, buttonHeight, {text_margin = 1, editing_locked = true})
      local letter = string.char(96+i)
      self.textareas[i]:addText(letter.." - ".. (text) .."\n")
      self.main_frame:addElement(self.textareas[i])
      self.main_frame:addElement(self.buttons[i])
      curY = curY + buttonHeight
    end

  self.main_frame:focusElement((1+self.focusIndex)*2)
end

function Menu:update(dt)
  self.main_frame:update(dt)
  self.main_frame.selected = true
 -----------------------REMOVE THIS-------------------
      for i,button in ipairs(self.buttons) do
       self.textareas[i].selected = self.buttons[i].selected
      end
-----------------------REMOVE UP-------------------

  --check the pressed status of each button to determine choiceIndex
  for i,button in ipairs(self.buttons) do
    if button.pressed then
      self.pressedIndex = i
    end
  end
  
  --using the text information in textList set self.choice to the correct object in inputList
  if self.pressedIndex and not self.choice then
    for i,object in ipairs(self.inputList) do
      if not self.choice then
        local text = object.name or object
        if text == self.textList[self.pressedIndex] then
          self.choice = self.inputList[i]
          self.choiceIndex = i
          break
        end
      end
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
  if not self.choice then
    if key == 'kp8' or key == 'up' then
      self:focusPrevious()
    elseif key == 'kp2' or key == 'down' then
      self:focusNext()
    elseif key == 'return' then
      self.buttons[self.focusIndex+1]:press()
    else
      local index = string.byte(key)-96
      if self.buttons[index] then
        self.buttons[index]:press()
      end
    end
  end
end
return Menu
