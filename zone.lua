local class = require "lib.middleclass"
ROT= require "lib.rotLove"
local serpent = require "lib.serpent"

require "lib.mapgeneration"
require "player"
require "feature"
--
--a zone is a mapped level
--
Zone = class("Zone")
local tempMap = {}
local rng=ROT.RNG.Twister:new()
rng:randomseed()

function Zone:initialize(player, width, height, mapType)
  self.player = player
  self.map = {}
  self.seen = {}
  self.field = {}
  self.width = width or 20
  self.height = height or 20
  self.mapType = mapType or "arena"
  
  self.items = {}
  self.feats = {}
  
  self:initMap()
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
  --self:cellDig()
  self:dungeonDig()
end

function diggerCallback(x, y, val)
    tempMap[x][y] = val
end

function Zone:cellDig()
  local iter = 5
	local percentage_walls = 5
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

function Zone:dungeonDig()
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
  
  --make doors and store them in feats table
  local doors = digger:getDoors()
  for i,door in ipairs(doors) do
    --                            name,       x,y, sheetX,sheetY, zone
    table.insert(self.feats, Feature("DOOR", door.x,door.y, 3,1))
    self.map[door.x][door.y] = 1
  end
end
function Zone:spawnPlayer()
  while true do
    local randX = rng:random(1,self.width)
    local randY = rng:random(1,self.height)
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
    local randX = rng:random(1,self.width)
    local randY = rng:random(1,self.height)
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

function Zone:save()
  --save everything but call the save functions on items and feats, maybe player too
  --for now save the map into map file
  local zdata = {}
  for k,v in pairs(self) do
      if k ~= "player" and k ~= "items" and k ~= "feats" and k~="class" then
        zdata[k] = v
      end
  end
  
  zdata["player"] = self.player:getData()
  
  local itemsData = {}
  for i, item in ipairs(self.items) do
    itemsData[i] = item:getData()
  end
  zdata["items"]  = itemsData
  
  local featsData = {}
  for i, feat in ipairs(self.feats) do
    featsData[i] = feat:getData()
  end
  zdata["feats"]  = featsData
  
  love.filesystem.write('z.lua', serpent.dump(zdata, {indent = ' ', sortkeys=true}) )
 -- love.filesystem.write('z.lua', serpent.dump(zdata))
  return
end

function Zone:load()

  --for now load the map from map file
  local data = loadstring(love.filesystem.read('z.lua')) ()
  
  -- i: index, d :dataTable contains info to init new feat
  for i, d in ipairs(data.feats) do
    self.feats[i] = Feature(d.name, d.x, d.y, d.sheetX, d.sheetY, d.isPassible, d.active)
  end
  data.feats = nil  --remove feats from data  
   
  -- i: index, d :dataTable contains info to init new item
  for i, d in ipairs(data.items) do
    self.items[i] = Item(d.name, d.x, d.y, d.sheetX, d.sheetY, d.onFloor)
  end
  data.items = nil  --remove items from data  
   
  local p = data.player
  self.player = Player(p.x, p.y, p.inv)
  data.player = nil --remove from data
  
  for k, v in pairs(data) do
    self[k] = v
  end
  
end