local class = require 'lib.middleclass'
require "player"
require "zone"
require "mLayer"
require "item"
require "screen"

Engine = class('Engine')
  
function Engine:initialize()
  self.player = Player()
  self.zone = Zone(self.player, 40, 40,"arena")
  self.zone:spawnItem(Item("KEY",1,1, 1,1))
  self.screen = Screen(MLayer(self.player, self.zone))
  
end

function Engine:movePlayer(dx,dy)
  if not (dx ==0 and dy == 0) then
        --check for wall and dungeon features
        local newX = self.player.x+dx
        local newY = self.player.y+dy
        
        
        --check if we are touching a feature
        for i,feat in ipairs(self.zone.feats) do
          --self.screen:sendMessage(newX..","..newY..feat.x)
          if newX == feat.x and newY == feat.y then
            
            feat:touch(self.zone)
          end
        end
        
        --floor is an allowed move
        if self.zone.map[newX][newY]==0 then 
            self.player:move(dx,dy)
        end
    end
end

function Engine:quit()
  love.event.quit()
end

function Engine:loadGame()
  --self.zone = lady.load_all('zone')
  
  self.zone:load()
  self.player = self.zone.player
  self.screen = Screen(MLayer(self.player, self.zone))
end

function Engine:restart()
  self.player = Player()
  self.zone = Zone(self.player, 40, 40,"arena")
  self.screen = Screen(MLayer(self.player, self.zone))

end

function Engine:save()
 self.zone:save()
end

