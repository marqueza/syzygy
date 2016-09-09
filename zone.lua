local class = require "lib/middleclass"
ROT= require "/lib/rotLove"
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
  self:dig()
  self.player.x, self.player.y = 2,2
  --self:spawnPlayer()
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
end

function Zone:dig()
  for i=1, self.width do
    for j=1, self.height do
      if i>1 and j>1 and i<self.width and j<self.height then
        self.map[i][j] = 0
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
      break
    end
  end
end