local class = require "lib/middleclass"
local ROT= require "lib.rotLove"

require "enitity"
require "actorsprite"
local actorInfo = require("actor_info")

Actor = class("Actor", Enitity)
Actor.id = 0
function Actor:initialize(args)
  
  --args can either be a single string or a table of arguments
  --after this block args will be a table of arguments
  if type(args) == 'string' then
    local actorName = args
    args = actorInfo[actorName]
  end
  
  self.name = args.name
  self.hp = args.hp or 2
  self.x = args.x or 1
  self.y = args.y or 1
  
  self.sheetX = args.sheetX or 1
  self.sheetY = args.sheetY or 1
  
  self.sprite = ActorSprite(self.name, 64*self.x, 64*self.y, self.sheetX or 1, self.sheetY or 1, "img/char.png")
  self.inv = {}
  if args.inv then
    --inventory, strings -> objects 
    for i, item in ipairs(args.inv) do
      if type(item) == 'string' then
        local itemName = item
        self.inv[i] = Item(itemName)
      elseif type(item) == 'table' then
        local itemArgs = item
        self.inv[i] = Item(itemArgs)
      end
    end
  end
  
    Actor.id = Actor.id + 1
    self.id = Actor.id
  
  self.faction = args.faction or 'foe'

  self.sprite.grid_x = self.x*self.sprite.charSize
  self.sprite.grid_y = self.y*self.sprite.charSize
  self.sprite.actual_x = self.x*self.sprite.charSize
  self.sprite.actual_y = self.y*self.sprite.charSize
end

function Actor:move(dx,dy, zone)
  assert( (dx == -1 or dx == 0 or dx == 1) and
          (dy == -1 or dy == 0 or dy == 1),
          "Invalid dx and dy values: must be -1,0,1")
  zone = zone or e.dungeon:getZone()

  --change direction of sprite
  if dx ~= 0 then 
    self.sprite.direction = dx
  end

  local newX = self.x+dx
  local newY = self.y+dy
  
  --check if we are bumping a player
  --[[if newX == e.player.x and newY == e.player.y then
    self:attack(e.player)
    return
  end
  --]]
  
  --check if we are bumping an actor
  local mob = zone:getActor(newX, newY)
  if mob then
    if self.faction ~= mob.faction then
      self:attack(mob)
    else
      if self.name == "player" then
        --player is displacing ally
        mob.x = self.x
        mob.y = self.y
        mob.sprite.grid_x = self.sprite.grid_x
        mob.sprite.grid_y = self.sprite.grid_y
        zone.map[mob.x][mob.y].actor = mob
        zone:regActor(mob)

        self.x = self.x + dx
        self.y = self.y + dy
        self.sprite.grid_x = self.x*self.sprite.charSize
        self.sprite.grid_y = self.y*self.sprite.charSize
        zone:regActor(self)
      else
        return
      end
    end
    return
  end
  
  --check if we are bumping a feat
  local feat = zone:getFeat(newX, newY)
  if feat then
    feat:bump(zone)
  end

  --floor is an allowed move
  if zone.map[newX][newY].isPassable then  
    zone:unregActor(self)
    self.x = self.x + dx
    self.y = self.y + dy
    self.sprite.grid_x = self.x*self.sprite.charSize
    self.sprite.grid_y = self.y*self.sprite.charSize
    zone:regActor(self)
    
  end


end

function Actor:teleport(x,y, newZone, oldZone)
  newZone = newZone or e.dungeon:getZone()
  if oldZone then oldZone:unregActor(self) end
  self.x = x
  self.y = y
  self.sprite.grid_x = x*self.sprite.charSize
  self.sprite.grid_y = y*self.sprite.charSize
  self.sprite.actual_x = x*self.sprite.charSize
  self.sprite.actual_y = y*self.sprite.charSize
  newZone:regActor(self)
end


function Actor:draw()
  if self.faction == "foe" then
    love.graphics.setColor(220,220,220,255)
  end
  self.sprite:draw()
  love.graphics.setColor(255,255,255,255)
end

function Actor:update(dt)
  self.sprite:update(dt)
end

function Actor:touch()
  e.screen:sendMessage("YOU TOUCH THE "..self.name..".")
end

function Actor:act(zone)
  
  zone = zone or e.dungeon:getZone()
  --randomMovement
  if self.name == "goo" then
    if (rng:random(1,2) == 1) then 
      local randX, randY = rng:random(-1,1), rng:random(-1,1)
      self:move(randX, randY, zone)
    end
  --seek player
  elseif self.faction == 'foe' then
    self:seek(e.player.x, e.player.y)
  elseif self.faction == 'ally' then
    --attack adj monsters
    local target = self:getAdjFoe(zone)
    if target then
      self:attack(target)
    else -- seek player
      self:seek(e.player.x, e.player.y)
    end
  end
end

function Actor:getAdjFoe(zone)
  local foes = {}
  for offX=-1,1,1 do
    for offY=-1,1,1 do 
      local target = zone:getActor(self.x+offX, self.y+offY)
      if target and target.faction ~= self.faction then
        table.insert(foes, target)
      end
    end
  end
  
  if foes[1] then
    return foes[1] 
  else
    return nil
  end
end
function Actor:seek(destX, destY, z)
  z = z or e.dungeon:getZone()
  local dijkstra = ROT.Path.Dijkstra(destX, destY,
      function (x, y)
        if z.map[x] and z.map[x][y] then
          return z.map[x][y].isPassable
        end
        return false
      end )

    local dij_step = 0
    local newX, newY = 0,0
    dijkstra:compute(self.x, self.y, 
      function(x, y)
        if dij_step == 1 then 
            self:move(x-self.x, y-self.y, z)
            first = false
        end
        dij_step = dij_step + 1
      end )
end
function Actor:getData()
  local data = {}
  for k,v in pairs(self) do
    if k ~= "sprite" and k~="class"  and k~= "inv" then
      data[k] = v
    end
  end

  local invData = {}
  for i,item in ipairs(self.inv) do
    invData[i] = item:getData()
  end

  data['inv'] = invData

  return data
end

function Actor:die()
  e.screen:sendMessage("The "..self.name.." dies.")
  
  --drop inventory
  for i, item in ipairs(self.inv) do
    self:dropItem(i)
  end
  
  local zone = e.dungeon:getZone()
  --remove entry from zone mob table
  for i,mob in ipairs(e.dungeon:getZone().mobs) do
    if self.id == mob.id then
      table.remove(zone.mobs, i)
    end
  end
  --unregister from zone
  zone:unregActor(self)
end

function Actor:dropItem(index, zone)
  e.screen:sendMessage("Dropped "..self.inv[index].name.." "..self.inv[index].id)
  zone = zone or e.dungeon:getZone()
  zone:placeItem(self.inv[index], self.x, self.y)
  table.remove(self.inv, index)
end

function Actor:attack(target)
  target.hp = target.hp - 1
  e.screen:sendMessage(self.name.." robusts the ".. target.name.. " hp: "..target.hp)
  if target.hp < 1 then 
    target:die()
  end
  
end