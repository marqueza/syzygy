local lovetoys = require "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local events = require "core.events.events"
local Serializable = require "data.serializable"
local MenuSystem = class("MenuSystem", System)
MenuSystem:include(Serializable)

local _setupComponentMenu
local _setupStringMenu

function MenuSystem:initialize()
    lovetoys.System.initialize(self)
    self.name = "MenuSystem"
    self.turn = 1
    self.text = ""
    self.choices = {}
    self.margin = 10
end

function MenuSystem:onDisplayNotify(MenuDisplayEvent)
    events.fireEvent(events.StateEvent{state="menu"})
    self.text = ""
    self.choices = {}
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
end

_setupComponentMenu = function (self, MenuDisplayEvent)
      local entities = systems.getEntitiesWithComponent(MenuDisplayEvent.choices[1])
      local i = 1
      for k, entity in pairs(entities) do
          self.choices[i] = entity.id
          local letter = string.char(96+i)
          self.text = self.text..letter.." - "..entity.name.."\n"
          i = i+1
      end
      self.text = string.upper(self.text)
end

_setupStringMenu = function (self, MenuDisplayEvent)
    self.choices = MenuDisplayEvent.choices
end

function MenuSystem:onCommmandNotify(MenuCommandEvent)
    local choiceIndex = string.byte(MenuCommandEvent.key)-96
    if self.choices[choiceIndex] then
        self.result = self.choices[choiceIndex]
        self.resultEventArgs[self.resultKey] = self.result
        events.fireEvent(self.resultEvent(self.resultEventArgs))
    end
    events.fireEvent(events.StateEvent{state="command"})
    self.visible = false
end
function MenuSystem:draw()
    if self.visible then
        love.graphics.print(self.text,
        self.margin+700,
        self.margin+44)
    end
end
function MenuSystem:requires()
    return {}
end

return MenuSystem
