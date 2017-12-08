local lovetoys = require "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local events = require "core.events.events"
local Serializable = require "data.serializable"
local systems = require "core.systems.systems"
local MenuSystem = class("MenuSystem", System)
MenuSystem:include(Serializable)

local _setupComponentMenu
local _setupStringMenu
local _closeMenu

function MenuSystem:initialize()
    lovetoys.System.initialize(self)
    self.name = "MenuSystem"
    self.turn = 1
    self.text = ""
    self.choices = {}
    self.marginWidth = 10
    self.marginHeight = 10
    self.defaultPixelX = game.options.viewportWidth/2+game.options.topBarHeight+5
    self.defaultPixelY = game.options.topBarHeight+5
    self.pixelX = self.defaultPixelX
    self.pixelY = self.defaultPixelY
    self.pixelWidth = 300
    self.pixelHeight = game.options.sideBarHeight
    self.backgroundImage = love.graphics.newImage('res/img/sprites/menu.png')
    self.menuStack = 0
end

function MenuSystem:onDisplayNotify(MenuDisplayEvent)
    events.fireEvent(events.StateEvent{state="menu"})
    self.text = ""
    self.choices = {}
    self.prettyChoices = {}
    self.menuStack = self.menuStack + 1
    if MenuDisplayEvent.type == "component" then
        _setupComponentMenu(self, MenuDisplayEvent)
    else
        _setupStringMenu(self, MenuDisplayEvent)
    end
    self.visible = true
    self.title = MenuDisplayEvent.title
    self.resultKey = MenuDisplayEvent.resultKey
    self.resultEvent = MenuDisplayEvent.resultEvent
    self.resultEventArgs = MenuDisplayEvent.resultEventArgs or {}
    self.persistant = MenuDisplayEvent.persistant
    self.pixelX = MenuDisplayEvent.pixelX or self.defaultPixelX
    self.pixelY = MenuDisplayEvent.pixelY or self.defaultPixelY
end

_setupComponentMenu = function (self, MenuDisplayEvent)
      local entities = systems.getEntitiesWithComponent(MenuDisplayEvent.choices[1])
      local i = 1
      for k, entity in pairs(entities) do
          self.choices[i] = entity.id
          local letter = string.char(96+i)
          if entity:has("Stack") then
              self.text = self.text..letter.." - "..entity.Stack.amount.." "..entity.name.."\n"
          else
              self.text = self.text..letter.." - "..entity.name.."\n"
          end
          i = i+1
      end
      self.text = string.upper(self.text)
end

_setupStringMenu = function(self, MenuDisplayEvent)
    self.choices = MenuDisplayEvent.choices
    self.prettyChoices = MenuDisplayEvent.prettyChoices or self.choices
    if MenuDisplayEvent.title then
      self.text = string.upper(MenuDisplayEvent.title) .. "\n"
    end
    for i, choice in ipairs(self.prettyChoices)  do
        local letter = string.char(96+i)
        self.text = self.text..letter.." "..choice.."\n"
      self.text = string.upper(self.text)
    end
end

function MenuSystem:onCommmandNotify(MenuCommandEvent)
  local choiceIndex = string.byte(MenuCommandEvent.key)-96
  if not self.persistant or self.choices[choiceIndex] then
    self.menuStack = self.menuStack - 1
    if self.menuStack == 0 then
      _closeMenu(self)
    end
  end
  if self.resultEvent then
    if self.choices[choiceIndex] then
      self.result = self.choices[choiceIndex]
      self.resultEventArgs[self.resultKey] = self.result
      events.fireEvent(self.resultEvent(self.resultEventArgs))
    end
  end
end
_closeMenu = function(self)
  events.fireEvent(events.StateEvent{state="command"})
  self.visible = false
end
function MenuSystem:draw()
    if self.visible then
        love.graphics.setColor(0,0,0, 255)
        love.graphics.rectangle("fill", 
          self.pixelX-2,
          self.pixelY-2,
          self.backgroundImage:getWidth()+4,
          self.backgroundImage:getHeight()+4)
        love.graphics.setColor(255,255,255)
        love.graphics.draw(self.backgroundImage,
          self.pixelX,
          self.pixelY)
        love.graphics.setColor(255,255,255)
        love.graphics.print(self.text,
        self.marginWidth+self.pixelX,
        self.marginHeight+self.pixelY)
    end
end
function MenuSystem:requires()
    return {}
end

return MenuSystem
