local class = require "lib/middleclass"
local ROT= require "lib.rotLove"

require "enitity"
require "actorsprite"

Actor = class("Actor", Enitity)
Actor.id = 0
function Actor:initialize(name, x, y, sheetX, sheetY, id, faction, inv)
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
  
  self.faction = faction or 'foe'

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
      if self.faction ~= mob.faction then
        self:attack(mob)
      else
        if self.name == "PLAYER" then
          mob.x = self.x
          mob.y = self.y
          mob.sprite.grid_x = self.sprite.grid_x
          mob.sprite.grid_y = self.sprite.grid_y
          
          self.x = self.x + dx
          self.y = self.y + dy
          self.sprite.grid_x = self.x*self.sprite.charSize
          self.sprite.grid_y = self.y*self.sprite.charSize
        else
          return
        end
      end
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
  --randomMovement
  if self.name == "GOO" then
    if (rng:random(1,2) == 1) then 
      local randX, randY = rng:random(-1,1), rng:random(-1,1)
      self:move(randX, randY, zone)
    end
    
  --seek player
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
    dijkstra:compute(self.x, self.y, 
      function(x, y)
        if dij_step == 1 then 
            self:move(x-self.x, y-self.y, z)
            first = false
        end
        dij_step = dij_step + 1
      end )
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
  
  --drop inventory
  for i, item in ipairs(self.inv) do
    self:dropItem(i)
  end
  
  --remove entry from zone mob table
  for i,mob in ipairs(e.dungeon:getZone().mobs) do
    if self.id == mob.id then
      table.remove(e.dungeon:getZone().mobs, i)
    end
  end
end

function Actor:dropItem(index, zone)
  zone = zone or e.dungeon:getZone()
  zone:placeItem(self.inv[index], self.x, self.y)
  table.remove(self.inv, index)
end

function Actor:attack(target)
  return
end