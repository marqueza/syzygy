local lovetoys = require "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local events = require "core.events.events"
local systems = require "core.systems.systems"
local TitleSystem = class("TitleSystem", System)

local _setupMainMenu

function TitleSystem:initialize()
    lovetoys.System.initialize(self)
    self.name = "TitleSystem"
    self.turn = 1
    self.text = ""
    self.choices = {}
    self.marginWidth = game.options.sideBarMarginWidth
    self.marginHeight = 15
    self.pixelX = game.options.viewportWidth
    self.pixelY = game.options.viewportHeight/5
    self.pixelWidth = game.options.sideBarWidth 
    self.pixelHeight = game.options.sideBarHeight
end

function TitleSystem:onEnterNotify(TitleEnterEvent)
  _setupMainMenu(self, TitleEnterEvent)
end

_setupMainMenu = function(self, TitleEnterEvent)
  events.fireEvent(events.MenuDisplayEvent{
      type="string",
      choices={"New", "Continue"},
      resultKey="selection",
      resultEvent=events.TitleSelectEvent,
      resultEventArgs={},
      persistant=true,
      pixelX = game.options.screenWidth/2-100,
      pixelY = game.options.screenHeight/2
    })
end

function TitleSystem:onSelectNotify(TitleSelectEvent)
  if TitleSelectEvent.selection == "New" then
    --delete the saved data
    systems.saveSystem:deleteSaves()
    --start game for reals
    events.fireEvent(events.LevelEvent{levelName="overWorld", levelDepth=0, options={first=true, spawnPlayer=game.options.player, spawnMinion=game.options.auto}})
    
    game.systems.targetSystem:refreshFocus()
  else
    --load the saved game
    events.fireEvent(events.LoadEvent{})
  end
end

function TitleSystem:draw()
end
function TitleSystem:requires()
    return {}
end

return TitleSystem
