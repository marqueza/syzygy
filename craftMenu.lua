local Theme = require('theme')
local UI = require 'lib.UI'
local class = require "lib.middleclass"
CraftMenu = class('CraftMenu', Menu)

local recipes = {
  {
    product = 'KEY GOLEM',
    ingredients = 
    {
      {name = 'KEY', amount = 5}
    }
  },
  
  {
    product = 'KEY FAIRY',
    ingredients = 
    {
      {name = 'KEY', amount = 1},
      {name = 'HEART', amount = 5},
    }
  },
  
}


--if product is selected then create a description panel, a textarea with same h,w as menu
--the panel contains:
--required:
--the ingredentes and amounts


--there must be a check to say if it can be built or not
--have description panel be created with ABLE or UNABLE

function CraftMenu:initialize(x, y)

  self.inputList = {}

  for i, recipe in ipairs(recipes) do
    self.inputList[i] = recipe.product
  end
  self.x = x
  self.y = y
  UI.DefaultTheme = Theme
  self.buttonHeight = 35
  local topMargin = self.buttonHeight
  self.focusIndex = 0
  self.choice = nil
  self.choiceIndex = nil
  self.pressedIndex = nil
  self.textList = {}
  self.dupList = {}
  self.outList = {}
  --store duplicates values in dupList
  for i,object in ipairs(self.inputList) do
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
  self.w = charCount*17

  self.main_frame = UI.Frame(self.x, self.y, self.w, #self.outList*self.buttonHeight, {closeable = true, draggable = true, drag_margin = topMargin})

  self.buttons = {}
  self.textareas = {}
  local curY = 0
  for i, text in ipairs(self.outList) do 
    self.buttons[i] = UI.Button(0,curY,self.w,self.buttonHeight)
    self.textareas[i] = UI.Textarea(0, curY, self.w, self.buttonHeight, {text_margin = 1, editing_locked = true})
    local letter = string.char(96+i)
    self.textareas[i]:addText(letter.." - ".. (text) .."\n")
    self.main_frame:addElement(self.textareas[i])
    self.main_frame:addElement(self.buttons[i])
    curY = curY + self.buttonHeight
  end

  self.main_frame:focusElement((1+self.focusIndex)*2)
  
  ---now craft menu specific
  --1+self.focusIndex is the index of the product
  -- info frame will display the recipe for that product
  -- height is the length of the ingrediants array times button height
  curY = 0
  self.info_frame = UI.Frame(self.x+self.w, self.y, self.w, #(recipes[self.focusIndex+1].ingredients)*self.buttonHeight)
  self.infoareas = {}
  
  for i, ingredient in ipairs(recipes[self.focusIndex+1].ingredients) do 
    self.infoareas[i] = UI.Textarea(0, curY, self.w, self.buttonHeight, {text_margin = 1, editing_locked = true})
    self.infoareas[i]:addText(ingredient.name .." ".. ingredient.amount .."\n")
    self.info_frame:addElement(self.infoareas[i])
    curY = curY + self.buttonHeight
  end
  
end



function CraftMenu:update(dt)
  self.main_frame:update(dt)
  self.main_frame.selected = true
  for i,button in ipairs(self.buttons) do
    self.textareas[i].selected = self.buttons[i].selected
  end
  
  --update text on info panel based on selection
  ---now craft menu specific
  --1+self.focusIndex is the index of the product
  -- info frame will display the recipe for that product
  -- height is the length of the ingrediants array times button height
  local curY = 0
  self.info_frame = UI.Frame(self.x+self.w, self.y, self.w, #(recipes[self.focusIndex+1].ingredients)*self.buttonHeight)
  self.infoareas = {}
  
  for i, ingredient in ipairs(recipes[self.focusIndex+1].ingredients) do 
    self.infoareas[i] = UI.Textarea(0, curY, self.w, self.buttonHeight, {text_margin = 1, editing_locked = true})
    self.infoareas[i]:addText(ingredient.name .." ".. ingredient.amount .."\n")
    self.info_frame:addElement(self.infoareas[i])
    curY = curY + self.buttonHeight
  end
  
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


function CraftMenu:draw()
  self.main_frame:draw()
  self.info_frame:draw()
end

function CraftMenu:focusNext()
  self.main_frame.selected = true
  self.focusIndex = (self.focusIndex + 1) % #(self.buttons)
  self.main_frame:focusElement((1+self.focusIndex)*2)
end

function CraftMenu:focusPrevious()
  self.main_frame.selected = true
  self.focusIndex = (self.focusIndex - 1) % #(self.buttons)
  self.main_frame:focusElement((1+self.focusIndex)*2)
end

function CraftMenu:keypressed(key)
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
return CraftMenu
