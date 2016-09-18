local class = require "lib/middleclass"
require "enitity"
require "actorsprite"

Actor = class("Actor", Enitity)
  
function Actor:initialize(name, x, y, sheetX, sheetY)
  Enitity.initialize(self, name, x, y)--invoke parent class Enitity
  
  self.sheetX = sheetX
  self.sheetY = sheetY
  self.sprite = ActorSprite(name, 64*x, 64*y, sheetX or 1, sheetY or 1, "img/char.png")
  
  self:teleport(x,y)
end

function Actor:move(dx,dy)
  self.x = self.x + dx
  self.y = self.y + dy
  self.sprite.grid_x = self.x*self.sprite.charSize
  self.sprite.grid_y = self.y*self.sprite.charSize

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