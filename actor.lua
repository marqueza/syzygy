local class = require "lib/middleclass"
require "enitity"
require "actorsprite"

Actor = class("Actor", Enitity)

function Actor:initialize(name, x, y, sheetX, sheetY, inv)
  Enitity.initialize(self, name, x, y)--invoke parent class Enitity

  self.sheetX = sheetX
  self.sheetY = sheetY
  self.sprite = ActorSprite(name, 64*x, 64*y, sheetX or 1, sheetY or 1, "img/char.png")
  self.inv = inv or {} -- if inv is a table of classes vs a table of data
  self:teleport(x,y)
end

function Actor:move(dx,dy, zone)

  --change direction of sprite
  if dx ~= 0 then 
    self.sprite.direction = dx
  end

  --check for wall and dungeon features
  local newX = self.x+dx
  local newY = self.y+dy

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
  if (rng:random(1,2) == 1) then 
    local randX, randY = rng:random(-1,1), rng:random(-1,1)
    self:move(randX, randY, zone)
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