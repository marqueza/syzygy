local class = require 'lib.middleclass'
require "player"
require "dungeon"
require "mLayer"
require "item"
require "screen"

Engine = class('Engine')


rng=ROT.RNG.Twister:new()
rng:randomseed()
function Engine:initialize()
  

  self.player = Player(1,1, nil, 4,1)
  self.dungeon = Dungeon(self.player, Zone(self.player, 20, 20, "DUNGEON", 1) )
  self.screen = Screen(MLayer(self.player, self.dungeon:getZone() ) )
  self.sched=ROT.Scheduler.Simple:new()
  for i=1,2 do self.sched:add(i, true) end
  self.turn = 1
  self.time = 1
  
end

function Engine:quit()
  love.event.quit()
end


function Engine:restart()
end

function Engine:nextTurn()
   self.turn = self.sched:next()
   self.time = self.time + 1
end

function Engine:downZone()
  self.dungeon:downZone()
  --update display
  self.screen = Screen(MLayer(self.player, self.dungeon:getZone() ))
end

function Engine:upZone()
  self.dungeon:upZone()
  --update display
  self.screen = Screen(MLayer(self.player, self.dungeon:getZone() ))
end


function Engine:save()
  self.dungeon:save()
end


function Engine:loadGame()
  
  self.dungeon:load()
  
  self.player = self.dungeon.player
  self.screen = Screen(MLayer(self.player, self.dungeon:getZone()))
end