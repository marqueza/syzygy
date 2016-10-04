local class = require "lib.middleclass"
ROT= require "lib.rotLove"


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
        --create floor
        self.map[x][y]:createFloor()
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
  digger:create( function (x, y, val) 
      if val == 0 then 
        self.map[x][y]:createFloor() 
      else
        self.map[x][y]:createWall() 
      end 
    end )
  
  --make doors and store them in feats table
  local doors = digger:getDoors()
  for i,door in ipairs(doors) do
    self:createDoor(door.x,door.y)
  end
  
  --place mobs
  local rooms = digger:getRooms()
  for i, room in ipairs(rooms) do
    local randX = rng:random(room:getLeft(), room:getRight())
    local randY = rng:random(room:getTop(), room:getBottom())
    local mob
    --[[
    if (rng:random(1,2) == 1) then
      mob = Actor('goo')
    else
      mob = Actor('skeleton')
    end
    --self:spawnMob(mob)
    
    --]]
  end
  
  --place stairs
  self:createDownStairs(self:getRandFloor())
  
end

function Zone:arenaDig()
  --dig out map
  digger=ROT.Map.Arena(self.width, self.height, opts)
  digger:create(function (x, y, val) 
      if val == 0 then
        self.map[x][y]:createFloor() 
      else
        self.map[x][y]:createWall() 
      end
    end)
  
  --place stairs
  self:createDownStairs(self:getRandFloor())
  
end

function Zone:nexusDig()
  self.themeOffset = 2
  
  --carve out an arena
  digger=ROT.Map.Arena(self.width, self.height, opts)
  digger:create(function (x, y, val) 
      if val == 0 then
        self.map[x][y]:createFloor() 
      else
        self.map[x][y]:createWall() 
      end
    end)
  
  --determine portal locations
  local margin = 5
  local x1 = math.floor(margin)
  local x2 = math.floor(self.width - margin)
  local y1 = math.floor(margin)
  local y2 = math.floor(self.height - margin)
  
  --place portals
  self:createPortal(x1,y1, 1)
  self:createPortal(x2,y1, 2)
  
end
