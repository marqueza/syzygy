local class = require "lib.middleclass"
ROT= require "lib.rotLove"
local serpent = require "lib.serpent"
Timer = require "lib.timer"

require "lib.mapgeneration"

require "actor"
require "feature"
require "item"
require "cell"

--
--a zone is a mapped level
--
Zone = class("Zone")

require "zone_builders"

function Zone:initialize(player, width, height, mapType, depth)
  self.player = player

  self.map = {}
  self.seen = {}
  self.field = {}
  
  self.width = width or 20
  self.height = height or 20
  self.mapType = mapType or "ARENA"
  self.depth = depth
  
  self.items = {}
  self.feats = {}
  self.mobs = {}
  
  self.themeOffset = 0
  
  self:initMap()
  
  self.fov=ROT.FOV.Precise:new( 
    function (fov, x, y)
      if self.map[x] and self.map[x][y] then
          return self.map[x][y].isOpaque==false
      end
      return false
    end
    )
  
  self:spawnPlayer()
  self.lastX = self.player.x
  self.lastY = self.player.y
  self:updateFov(self.player.x, self.player.y)
end

function Zone:initMap()
  self.map = {}
  self.seen = {}
  self.field = {}
  
  for x=1,self.width do
    self.map[x] = {}
    self.seen[x] = {}
    self.field[x] = {}
    
    for y=1,self.height do
      self.map[x][y] = Cell()
      self.seen[x][y] = 0
      self.field[x][y] = 0
    end
  end

  Zone[self.mapType..'Dig'](self)
  
end
function Zone:zeroTable(t)
    for x=1,self.width do
      t[x] = {}
    
    for y=1,self.height do
      t[x][y] = 0
    end
  end
end
function Zone:updateFov(x,y)
  self:zeroTable(self.field)
  self.fov:compute(x, y, 15, 
    function (x, y, r, v)
      
      if self.map[x] and self.map[x][y] then
        self.field[x][y]=1
        self.seen[x][y]=1
      end
    end
    )
end

function Zone:getRandFloor(x1,y1, x2,y2)
  while true do
    local randX = rng:random(x1 or 1, x2 or self.width)
    local randY = rng:random(y1 or 1,y2 or self.height)
    if self.map[randX][randY].isPassable then
      return randX, randY
    end
  end
end

function Zone:spawnMob(mob)
  if mob.x == 1 and mob.y == 1 then
    local randX, randY = self:getRandFloor()
    mob:teleport(randX, randY, self, nil)
  end
  mob:teleport(mob.x, mob.y, self, self)
  table.insert(self.mobs, mob)
  
  self:regActor(mob)
end

function Zone:spawnPlayer()
  local randX, randY = self:getRandFloor()
  self.map[randX][randY].actor = self.player
  self.player:teleport(randX,randY, self, nil)
end

function Zone:createUpStairs(x, y)
  local ani = {
    active={x=6,y=2},
    inert={x=6,y=2}
  }
  local feat = Feature("UP STAIRWAY", x,y, ani, true)
  table.insert(self.feats, feat)
  self:regFeat(feat)
end

function Zone:createDownStairs(x, y)
  local ani = {
    active={x=5,y=2},
    inert={x=5,y=2}
  }
  local feat = Feature("DOWN STAIRWAY", x,y, ani, true)
  table.insert(self.feats, feat)
  self:regFeat(feat)
end

function Zone:createDoor(x, y)
  local ani = {
    active={x=3,y=1},
    inert={x=4,y=1}
  }
  local feat = Feature("DOOR", x,y, ani)
  table.insert(self.feats, feat)
  self:regFeat(feat)
  
  self.map[feat.x][feat.y]:createWall()
end

function Zone:createPortal(x, y, theme)
  
  local ani = {
    active={x='7-10',y=theme},
    inert={x='7-10',y=theme}
  }
  
  local feat = Feature("portal", x, y, ani)
  table.insert(self.feats, feat)
  self:regFeat(feat)
  
end

function Zone:spawnItem(item)
  table.insert(self.items, item)
  local randX, randY = self:getRandFloor()
  item:place(randX,randY)
  table.insert(self.map[randX][randY].inv, item)
end

function Zone:placeItem(item, x, y)
  item.onFloor = false
  item:place(x,y, self)
  table.insert(self.items,item)
  --delay for smoother sprite placement
  Timer.after(.05, function ()  item.onFloor = true end) 
end



function Zone:invokeMobs()
  for i,mob in ipairs(self.mobs) do
    mob:act(self)
  end
end

function Zone:update(dt)
  if not self.Map == tempMap then
    self.Map = tempMap
  end
end

function Zone:regActor(actor)
  self.map[actor.x][actor.y].actor = actor
end

function Zone:unregActor(actor)
  --assert(self.map[actor.x][actor.y].actor, "Actor not in map location.")
  self.map[actor.x][actor.y].actor = nil
end

function Zone:getActor(x,y)
  return self.map[x][y].actor
end


function Zone:regItem(item)
  table.insert(self.map[item.x][item.y].inv, item)
end

function Zone:unregItem(item)
  for i, floorItem in ipairs(self.map[item.x][item.y].inv) do
    if item.name == floorItem.name then
      table.remove(self.map[item.x][item.y].inv, i)
      return
    end
  end
end

function Zone:getInv(x,y)
  return self.map[x][y].inv
end

function Zone:getItem(x,y)
  return self.map[x][y].inv[1]
end


function Zone:regFeat(feat)
  self.map[feat.x][feat.y].feat = feat
end

function Zone:unregFeat(feat)
  self.map[feat.x][feat.y].feat = nil
end

function Zone:getFeat(x,y)
  return self.map[x][y].feat
end

function Zone:save()
  --save everything but call the save functions on items and feats, maybe player too
  --for now save the map into map file
  local zdata = {}
  for k,v in pairs(self) do
      if k ~= "player" and k ~= "items" and k ~= "feats" and k~="fov" and k~="class" and k~= "map" then
        zdata[k] = v
      end
  end
  
  local mobsData = {}
  for i, mobs in ipairs(self.mobs) do
    mobsData[i] = mobs:getData()
  end
  zdata["mobs"]  = mobsData
  
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
  
  local mapData = {}
  for i in ipairs(self.map) do
    for j in ipairs(self.map[i]) do
      if j == 1 then mapData[i] = {} end
      mapData[i][j] = self.map[i][j]:getData()
    end
  end
  zdata["map"] = mapData
  
  love.filesystem.write('z'..self.depth..'.lua', serpent.dump(zdata, {indent = ' ', sortkeys=true}) )
  return
end

function Zone:load(depth)

  --for now load the map from map file
  local data = loadstring(love.filesystem.read('z'..depth..'.lua')) ()
  
  --recreate the map cells objects
  for i in ipairs(data.map) do
    for j, d in ipairs(data.map[i]) do 
      if j == 1 then self.map[i] = {} end
      self.map[i][j] = Cell(d.tile, d.isPassable, d.isOpaque)
      self.map[i][j].isOpaque = d.isOpaque
    end
  end
  data.map = nil -- remove the map array from data
    
  
  -- i: index, d :dataTable contains info to init new feat
  for i, d in ipairs(data.feats) do
    self.feats[i] = Feature(d.name, d.x, d.y, d.sheetX, d.sheetY, d.isPassable, d.active)
    self:regFeat(self.feats[i])
  end
  data.feats = nil  --remove feats from data  

  -- i: index, d :dataTable contains info to init new item
  for i, d in ipairs(data.items) do
    self.items[i] = Item(d)
    self:regItem(self.items[i])
  end
  data.items = nil  --remove items from data  
  
  -- i: index, d :dataTable contains info to init new item
  for i, d in ipairs(data.mobs) do
    self.mobs[i] = Actor(d)
    self:regActor(self.mobs[i])
  end
  --fix the inv
  data.mobs = nil  --remove items from data  
  

  
     
  for k, v in pairs(data) do
    self[k] = v
  end
  
end