local class = require "lib/middleclass"
local ROT= require "lib.rotLove"

require "enitity"
require "actorsprite"

Actor = class("Actor", Enitity)
Actor.id = 0
function Actor:initialize(name, x, y, sheetX, sheetY, id, inv)
  Enitity.initialize(self, name, x, y)--invoke parent class Enitity

  self.sheetX = sheetX
  self.sheetY = sheetY
  self.sprite = ActorSprite(name, 64*x, 64*y, sheetX or 1, sheetY or 1, "img/char.png")
  self.inv = inv or {} -- if inv is a table of classes vs a table of data
  if id then
    self.id = id
  else
    Actor.id = Actor.id + 1
    self.id = Actor.id
  end

  self:teleport(x,y)
end

function Actor:move(dx,dy, zone)
  assert( (dx == -1 or dx == 0 or dx == 1) and
          (dy == -1 or dy == 0 or dy == 1),
          "Invalid dx and dy values: must be -1,0,1")
  zone = e.dungeon:getZone()

  --change direction of sprite
  if dx ~= 0 then 
    self.sprite.direction = dx
  end

  --check for wall and dungeon features
  local newX = self.x+dx
  local newY = self.y+dy

  --check if we are bumping a player
  if newX == e.player.x and newY == e.player.y then
    return
  end
  
  --check if we are bumping an actor
  for i,mob in ipairs(zone.mobs) do
    if newX == mob.x and newY == mob.y then
      self:attack(mob)
      return
    end
  end
  --check if we are bumping a feature
  for i,feat in ipairs(zone.feats) do
    if newX == feat.x and newY == feat.y then
      feat:bump(zone)
    end
  end

  --floor is an allowed move
  if zone.map[newX][newY]==0 then  
    self.x = self.x + dx
    self.y = self.y + dy
    self.sprite.grid_x = self.x*self.sprite.charSize
    self.sprite.grid_y = self.y*self.sprite.charSize
  end


end

function Actor:teleport(x,y)
  self.x = x
  self.y = y
  self.sprite.grid_x = x*self.sprite.charSize
  self.sprite.grid_y = y*self.sprite.charSize
  self.sprite.actual_x = x*self.sprite.charSize
  self.sprite.actual_y = y*self.sprite.charSize
end


function Actor:draw()
  self.sprite:draw()
end

function Actor:update(dt)
  self.sprite:update(dt)
end

function Actor:touch()
  e.screen:sendMessage("YOU TOUCH THE "..self.name..".")
end

function Actor:act(zone)

  if self.name == "GOO" then
    if (rng:random(1,2) == 1) then 
      local randX, randY = rng:random(-1,1), rng:random(-1,1)
      self:move(randX, randY, zone)
    end
    --seek and destroy player
  else
    local z = e.dungeon:getZone()
    local dijkstra = ROT.Path.Dijkstra(e.player.x, e.player.y,
      function (x, y)
        if z.map[x] and z.map[x][y] then
          return z.map[x][y]==0
        end
        return false
      end )

    local dij_step = 0
    local newX, newY = 0,0
    local oldX, oldY = self.x, self.y
    dijkstra:compute(oldX, oldY, 
      function(x, y)
        if dij_step == 1 then 
          --if x == oldX or y == oldY then
            self:move(x-self.x, y-self.y, z)
            first = false
          --end
        end
        dij_step = dij_step + 1
      end )
    local dx = newX - self.x
    local dy = newY - self.y
    --self:teleport(newX, newY)
  end
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
  for i,mob in ipairs(e.dungeon:getZone().mobs) do
    if self.id == mob.id then
      table.remove(e.dungeon:getZone().mobs, i)
    end
  end
end
function Actor:attack(target)
  return
end