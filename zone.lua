local class = require "lib.middleclass"
ROT= require "lib.rotLove"
require "lib.mapgeneration"
require "player"

--
--a zone is a mapped level
--
Zone = class("Zone")

function Zone:initialize(player, name, width, height, mapType)
  self.player = player
  self.name = name or "grey"
  self.map = {}
  self.seen = {}
  self.field = {}
  self.width = width or 20
  self.height = height or 20
  self.mapType = mapType or "arena"

  self:initMap()
  --self:dig()
  self.player.x, self.player.y = 1,1
  self:spawnPlayer()
end

function Zone:initMap()
  self.map = {}
  self.seen = {}
  for x=1,self.width do
    self.map[x] = {}
    self.seen[x] = {}
    for y=1,self.height do
      self.map[x][y] = 1
      self.seen[x][y] = 0
    end
  end
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
  local tempMap = maps.generate.cellular (self.width, self.height, iter, percentage_walls, rules)
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
  local rng=ROT.RNG.Twister:new()
  rng:randomseed()
  while true do
    local randX = rng:random(1,self.width)
    local randY = rng:random(1,self.height)
    if self.map[randX][randY] == 0 then
      self.player.x, self.player.y = randX, randY
      
      self.player.sprite.grid_x = self.player.x*64
      self.player.sprite.grid_y = self.player.y*64
      break
    end
  end
end