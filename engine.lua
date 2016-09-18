local class = require 'lib.middleclass'
require "player"
require "dungeon"
require "mLayer"
require "item"
require "screen"

Engine = class('Engine')
  
function Engine:initialize()
  self.player = Player(1,1, nil, 1,1)
  self.dungeon = Dungeon(self.player, Zone(self.player, 20, 20, "DUNGEON", 1) )
  self.screen = Screen(MLayer(self.player, self.dungeon:getZone() ) )
end

function Engine:movePlayer(dx,dy)
  if not (dx ==0 and dy == 0) then
        --change direction of sprite
        if dx ~= 0 then 
          self.player.sprite.direction = dx
        end
        
        --check for wall and dungeon features
        local newX = self.player.x+dx
        local newY = self.player.y+dy
        
        
        --check if we are touching a feature
        for i,feat in ipairs(self.dungeon:getZone().feats) do
          --self.screen:sendMessage(newX..","..newY..feat.x)
          if newX == feat.x and newY == feat.y then
            
            feat:bump(self.dungeon:getZone())
          end
        end
        
        --floor is an allowed move
        if self.dungeon:getZone().map[newX][newY]==0 then 
            self.player:move(dx,dy)
            self.dungeon:getZone():updateFov(self.player.x, self.player.y)
        end
    end
end


function Engine:quit()
  love.event.quit()
end


function Engine:restart()
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