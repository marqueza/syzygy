local class = require "lib.middleclass"
ROT= require "lib.rotLove"
local serpent = require "lib.serpent"
Timer = require "lib.timer"

require "lib.mapgeneration"

require "actor"
require "feature"
--
--a zone is a mapped level
--
Zone = class("Zone")


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
  
  self:initMap()
  
  self.fov=ROT.FOV.Precise:new( 
    function (fov, x, y)
      if self.map[x] and self.map[x][y] then
          return self.map[x][y]==0
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
      self.map[x][y] = 1
      self.seen[x][y] = 0
      self.field[x][y] = 0
    end
  end
  
  if self.mapType == "CELL" then
    self:cellDig()
  elseif self.mapType == "DUNGEON" then
    self:dungeonDig()
  elseif self.mapType == "ARENA" then
    self:arenaDig()
  end
  
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
  self.fov:compute(x, y, 10, 
    function (x, y, r, v)
      
      if self.map[x] and self.map[x][y] then
        self.field[x][y]=1
        self.seen[x][y]=1
      end
    end
    )
end

function Zone:cellDig()
  local iter = 5
	local percentage_walls = 30
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

function Zone:dungeonDig()
  --dig out map
  local opts ={
    roomWidth={3,8},
    roomHeight={3,5},
    corridorLength={4,7},
    dugPercentage=0.4,
    timeLimit=1000,
    nocorridorsmode=true
  }
  local digger=ROT.Map.Digger(self.width, self.height, opts)
  digger:create( function (x, y, val) self.map[x][y] = val end )
  
  --make doors and store them in feats table
  local doors = digger:getDoors()
  for i,door in ipairs(doors) do
    --                            name,       x,y, sheetX,sheetY, zone
    table.insert(self.feats, Feature("DOOR", door.x,door.y, 3,1))
    self.map[door.x][door.y] = 1
  end
  
  --place mobs
  local rooms = digger:getRooms()
  for i, room in ipairs(rooms) do
    if (rng:random(1,2) == 1) then
      local randX = rng:random(room:getLeft(), room:getRight())
      local randY = rng:random(room:getTop(), room:getBottom())
      local mob = Actor(
        "GOO", 
        randX,randY, 
        1,2, 
        nil,
        'foe',
        {Item("GREY MATTER", 1,1, '1-2',4, false)}
        )
      table.insert(self.mobs, mob)
    else
      local randX = rng:random(room:getLeft(), room:getRight())
      local randY = rng:random(room:getTop(), room:getBottom())
      local mob = Actor(
        "SKELETON", 
        randX,randY, 
        3,2, 
        nil, 
        'foe',
        {Item("BONES", 1,1, 4,3, false) }
        )
      table.insert(self.mobs, mob)
    end
  end
  
  --place stairs
  local feat = Feature("DOWN STAIRWAY", 1,1, 5,1, true)
  table.insert(self.feats, feat)
  feat:place(self:getRandFloor())
  
end

function Zone:arenaDig()
  --dig out map
  digger=ROT.Map.Arena(self.width, self.height, opts)
  digger:create(function (x, y, val) self.map[x][y] = val end)
  
  --place stairs
  local feat = Feature("DOWN STAIRWAY", 1,1, 5,1, true)
  table.insert(self.feats, feat)
  feat:place(self:getRandFloor())
  
end

function Zone:getRandFloor()
  while true do
    local randX = rng:random(1,self.width)
    local randY = rng:random(1,self.height)
    if self.map[randX][randY] == 0 then
      return randX, randY
    end
  end
end

function Zone:spawnMob(mob)
  local randX, randY = self:getRandFloor()
  mob:teleport(randX, randY)
  table.insert(self.mobs, mob)
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

function Zone:createUpStairs(x, y)
  local feat = Feature("UP STAIRWAY", x,y, 6,1, true)
  table.insert(self.feats, feat)
end

function Zone:createDownStairs(x, y)
  local feat = Feature("DOWN STAIRWAY", x,y, 6,1, true)
  table.insert(self.feats, feat)
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

function Zone:placeItem(item, x, y)
  item.onFloor = false
  item:place(x,y)
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

function Zone:save()
  --save everything but call the save functions on items and feats, maybe player too
  --for now save the map into map file
  local zdata = {}
  for k,v in pairs(self) do
      if k ~= "player" and k ~= "items" and k ~= "feats" and k~="fov" and k~="class" then
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
  
  love.filesystem.write('z'..self.depth..'.lua', serpent.dump(zdata, {indent = ' ', sortkeys=true}) )
  return
end

function Zone:load(depth)

  --for now load the map from map file
  local data = loadstring(love.filesystem.read('z'..depth..'.lua')) ()
  
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
  
  -- i: index, d :dataTable contains info to init new item
  for i, d in ipairs(data.mobs) do
    self.mobs[i] = Actor(d.name, d.x, d.y, d.sheetX, d.sheetY, d.id, d.faction)
    for j, item in ipairs(d.inv) do -- iterate through the new actor and re-populate its inv
      table.insert(self.mobs[i].inv, Item(item.name, item.x, item.y, item.sheetX, item.sheetY, item.onFloor) )
    end
  end
  --fix the inv
  data.mobs = nil  --remove items from data  
     
  for k, v in pairs(data) do
    self[k] = v
  end
  
end