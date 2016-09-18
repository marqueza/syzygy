local class = require 'lib.middleclass'
local serpent = require "lib.serpent"
require "player"
require "zone"

Dungeon = class('Dungeon')

function Dungeon:initialize(player, startingZone)
  self.player = player
  self.zones = {startingZone} or {Zone(self.player, 20, 20, "ARENA", 1)} 
  self.depth = 1
  self.maxDepth = 1
end

function Dungeon:getZone()
  return self.zones[self.depth]
end

function Dungeon:downZone()
  --go through features
  for i,feat in ipairs(self.zones[self.depth].feats) do
    --check if feature is a stair or portal and player is on it
    if feat.name == "DOWN STAIRWAY" and self.player.x == feat.x and self.player.y == feat.y then
      self.zones[self.depth].lastX = self.player.x
      self.zones[self.depth].lastY = self.player.y
      
      self.depth = self.depth+1
      self.maxDepth = math.max(self.depth, self.maxDepth)
     
      if not self.zones[self.depth] then 
        --set up new zone
        
        if self.depth ~= 3 then
        self.zones[self.depth] = Zone(self.player, 20, 20, "DUNGEON", self.depth)
        self.zones[self.depth]:createUpStairs(self.player.x, self.player.y)
        
        else
        self.zones[self.depth] = Zone(self.player, 50, 50, "CELL", self.depth)
        self.zones[self.depth]:createUpStairs(self.player.x, self.player.y)
          local z = self:getZone()
          
          --remove downstairs
          for i,feat in ipairs(z.feats) do
            if feat.name == "DOWN STAIRWAY" then
              table.remove(z.feats,i)
            end
          end
          
          --place gateway
          local randX, randY = z:getRandFloor()
          table.insert(z.feats, Feature("GLASS GATE", randX,randY, 7,1, false))
          z.map[randX][randY] = 1
        end
      else
        --visit old zone
        self.player:teleport(self.zones[self.depth].lastX, self.zones[self.depth].lastY)
      end
    end
  end
end

function Dungeon:upZone()
  --go through features
  for i,feat in ipairs(self.zones[self.depth].feats) do
    --check if feature is a stair or portal and player is on it
    if feat.name == "UP STAIRWAY" and self.player.x == feat.x and self.player.y == feat.y then
      
      self.zones[self.depth].lastX, self.zones[self.depth].lastY = self.player.x, self.player.y

      if not self.zones[self.depth-1] then --exit the dungeon
        --enter the nexus
        self.zones = {Zone(self.player, 20, 20, "ARENA", 1)}
      else
        --elevate
        self.depth = self.depth - 1
        self.player:teleport(self.zones[self.depth].lastX, self.zones[self.depth].lastY)
      end
    end
  end
end

function Dungeon:save()
  --save each zone in a z1.lua to zN.lua file
  for i, zone in ipairs(self.zones) do
    zone:save()
  end
  
  --save rest of the properites in d.lua file
  local data = {}
  data["player"] = self.player:getData()
  
  for k,v in pairs(self) do
      if k ~= "player" and k ~= "zones" and k~="class" then
        data[k] = v
      end
  end
  love.filesystem.write('d.lua', serpent.dump(data, {indent = ' ', sortkeys=true}) ) 
end

function Dungeon:load()
  
  --read and store dungeon data into data
  local data = loadstring(love.filesystem.read('d.lua')) ()
  
  --load data except for zones
  for k, v in pairs(data) do
    if k ~= "zones" and k~= "player" then 
      self[k] = v
    end
  end
  
  --create and rebuild zones
  for i=1, self.maxDepth do
    self.zones[i] = Zone(self.player, 10,10, "CELL", 1) 
    self.zones[i]:load(i)
  end
  
  local p = data.player
  self.player = Player(p.x, p.y, p.inv)
end