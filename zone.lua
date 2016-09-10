local class = require "lib.middleclass"
ROT= require "lib.rotLove"
require "lib.mapgeneration"
require "player"

--
--a zone is a mapped level
--
Zone = class("Zone")
local tempMap = {}

function Zone:initialize(player, name, width, height, mapType)
  self.player = player
  self.name = name or "grey"
  self.map = {}
  self.seen = {}
  self.field = {}
  self.width = width or 20
  self.height = height or 20
  self.mapType = mapType or "arena"
  self.rng=ROT.RNG.Twister:new()
  self.rng:randomseed()
  
  self.items = {}

  self:initMap()
  --self:dig()
  self.player.x, self.player.y = 1,1
  self:spawnPlayer()
end

function Zone:initMap()
  self.map = {}
  self.seen = {}
  tempMap = {}
  for x=1,self.width do
    self.map[x] = {}
    self.seen[x] = {}
    tempMap[x] = {}
    for y=1,self.height do
      self.map[x][y] = 1
      self.seen[x][y] = 0
      tempMap[x][y] = 1
    end
  end
    local opts ={
    roomWidth={3,8},
    roomHeight={3,5},
    corridorLength={4,7},
    dugPercentage=0.4,
    timeLimit=1000,
    nocorridorsmode=true
  }
  digger=ROT.Map.Digger(self.width, self.height, opts)
  --digger:randomize(.5)
  digger:create(diggerCallback)
  self.map = tempMap
  local doors = digger:getDoors()
  for i,door in ipairs(doors) do
    self.map[door.x][door.y] = 2
  end
  
end

function diggerCallback(x, y, val)
    tempMap[x][y] = val
end

function Zone:cellDig()
  local iter = 5
	local percentage_walls = 35
  local rules = {}
	rules.neighborhood = 1
	rules.include_self = true
	rules.frame = "start"
	rules[0] = "floor"
	rules[1] = "floor"
	rules[2] = "stay"
	rules[3] = "wall"
	rules[4] = "wall"
	rules[5] = "wall"
  tempMap = maps.generate.cellular (self.width, self.height, iter, percentage_walls, rules)
  tempMap = maps.process.removeDisconnected (tempMap)
  for x=1,self.width do
    for y=1,self.height do
      if not tempMap[x][y] then
        self.map[x][y] = 0
      end
    end
  end
end

function Zone:spawnPlayer()
  while true do
    local randX = self.rng:random(1,self.width)
    local randY = self.rng:random(1,self.height)
    if self.map[randX][randY] == 0 then
      self.player:teleport(randX,randY)
      break
    end
  end
end

function Zone:spawnItem(item)
  --store in in table
  table.insert(self.items, item)
  
  --determine spawn point
  
  while true do
    local randX = self.rng:random(1,self.width)
    local randY = self.rng:random(1,self.height)
    if self.map[randX][randY] == 0 then
      item:place(randX,randY)
      break
    end
  end
end
  
function Zone:update(dt)
  if not self.Map == tempMap then
    self.Map = tempMap
  end
end