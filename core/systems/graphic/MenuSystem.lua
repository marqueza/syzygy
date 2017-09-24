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
    self.marginWidth = game.options.sideBarMarginWidth
    self.marginHeight = 15
    self.defaultPixelX = 0
    self.defaultPixelY = game.options.topBarHeight
    self.pixelX = self.defaultPixelX
    self.pixelY = self.defaultPixelY
    self.pixelWidth = game.options.sideBarWidth 
    self.pixelHeight = game.options.sideBarHeight
end

function MenuSystem:onDisplayNotify(MenuDisplayEvent)
    events.fireEvent(events.StateEvent{state="menu"})
    self.text = ""
    self.choices = {}
    self.prettyChoices = {}
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
    for i, choice in ipairs(self.prettyChoices)  do
        local letter = string.char(96+i)
        self.text = self.text..letter.." - "..choice.."\n"
      self.text = string.upper(self.text)
    end
end

function MenuSystem:onCommmandNotify(MenuCommandEvent)
    if self.resultEvent then
        local choiceIndex = string.byte(MenuCommandEvent.key)-96
        if self.choices[choiceIndex] then
            self.result = self.choices[choiceIndex]
            self.resultEventArgs[self.resultKey] = self.result
            events.fireEvent(self.resultEvent(self.resultEventArgs))
           _closeMenu(self)
        end
    end
    if not self.persistant then
      _closeMenu(self)
    end
end
_closeMenu = function(self)
  events.fireEvent(events.StateEvent{state="command"})
  self.visible = false
end
function MenuSystem:draw()
    if self.visible then
      --[[
        love.graphics.setColor(0,0,0, 100)
        love.graphics.rectangle("fill", 
          self.pixelX,
          self.pixelY,
          self.pixelWidth,
          self.pixelHeight)
        love.graphics.setColor(255,255,255)
        --]]
        love.graphics.print(self.text,
        self.marginWidth+self.pixelX,
        self.marginHeight+self.pixelY)
    end
end
function MenuSystem:requires()
    return {}
end

return MenuSystem
