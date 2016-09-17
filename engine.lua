local class = require 'lib.middleclass'
require "player"
require "zone"
require "mLayer"
require "item"
require "screen"

Engine = class('Engine')
  
function Engine:initialize()
  self.player = Player(1,1, nil, 1,1)
  self.zone = Zone(self.player, 40, 40, "DUNGEON")
  self.dungeon = {self.zone}
  self.depth = 1
  
  self.zone:spawnItem(Item("KEY",1,1, 1,1))
  self.screen = Screen(MLayer(self.player, self.zone))
  
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
        for i,feat in ipairs(self.zone.feats) do
          --self.screen:sendMessage(newX..","..newY..feat.x)
          if newX == feat.x and newY == feat.y then
            
            feat:bump(self.zone)
          end
        end
        
        --floor is an allowed move
        if self.zone.map[newX][newY]==0 then 
            self.player:move(dx,dy)
        end
    end
end

function Engine:downZone()
  --go through features
  for i,feat in ipairs(self.zone.feats) do
    --check if feature is a stair or portal and player is on it
    if feat.name == "DOWN STAIRWAY" and self.player.x == feat.x and self.player.y == feat.y then
      self.depth = self.depth+1
      self.zone.lastX, self.zone.lastY = self.player.x, self.player.y
      if not self.dungeon[self.depth] then --next zone does not exist
        self.dungeon[self.depth] = Zone(self.player, 40, 40, "DUNGEON")
        --change current zone
        self.zone = self.dungeon[self.depth]
        --new upstairs
        self.zone:createUpStairs(self.player.x, self.player.y)
      else
        self.zone = self.dungeon[self.depth]
        self.player:teleport(self.zone.lastX, self.zone.lastY)
      end
      
      --update display
      self.screen = Screen(MLayer(self.player, self.zone))
    end
  end
end

function Engine:upZone()
  --go through features
  for i,feat in ipairs(self.zone.feats) do
    --check if feature is a stair or portal and player is on it
    if feat.name == "UP STAIRWAY" and self.player.x == feat.x and self.player.y == feat.y then
      
      self.zone.lastX, self.zone.lastY = self.player.x, self.player.y

      if not self.dungeon[self.depth-1] then --exit the dungeon
        --enter the nexus
        self.dungeon = {Zone(self.player, 20, 20, "ARENA")}
        --change current zone
        self.zone = self.dungeon[self.depth]
      else
        --elevate
        self.depth = self.depth - 1
        self.zone = self.dungeon[self.depth]
        self.player:teleport(self.zone.lastX, self.zone.lastY)
      end
      
      --update display
      self.screen = Screen(MLayer(self.player, self.zone))
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

