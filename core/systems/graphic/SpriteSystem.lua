local lovetoys = require "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local SpriteSystem = class("SpriteSystem", lovetoys.System)

function SpriteSystem:initialize()
  love.window.setMode(1280,720)
  local font = love.graphics.setNewFont("res/font/tamsyn_bold.pcf", 16)
  font:setFilter("nearest", "nearest")
  lovetoys.System.initialize(self)
  self.maxCount = 4
  self.layers = {}
  self.pixelWidth = game.options.viewportWidth
  self.pixelHeight = game.options.viewportHeight
  self.horizontalTileMax = self.pixelWidth/game.options.spriteSize
  self.verticalTileMax = self.pixelHeight/game.options.spriteSize
end

--function declaration
local _drawSprite

function SpriteSystem:draw()
  local count = (math.floor(game.time) % self.maxCount) + 1
  --for layerName, entities in pairs(self.layers) do

    
  local entities = self.layers["floor"]

  if entities then
    for key, spriteEntity in pairs(entities) do
      _drawSprite(self, spriteEntity, count)
    end
  end

  entities = self.layers["backdrop"]
  if entities then
    for key, spriteEntity in pairs(entities) do
      _drawSprite(self, spriteEntity, count)
    end
  end

  entities = self.layers["display"]
  if entities then
    for key, spriteEntity in pairs(entities) do
      _drawSprite(self, spriteEntity, count)
    end
  end


  entities = self.layers["character"]
  if entities then
    for key, spriteEntity in pairs(entities) do
      _drawSprite(self, spriteEntity, count)
    end
  end
  
  --This rectangle is to defind the area of the viewfinder
  --[[
  love.graphics.setColor(150,250,0)
  love.graphics.rectangle( "line", 0, 0, self.pixelWidth, self.pixelHeight )
  love.graphics.setColor(255,255,255)
  --]]
end

function SpriteSystem:update()

end
function SpriteSystem:requires()
  return {"Physics", "Sprite"}
end

_drawSprite = function(self, spriteEntity, count)
  local Physics = spriteEntity:get("Physics")
  local Sprite = spriteEntity:get("Sprite")
  if not Sprite.isVisible then
    return
  end
  
  --Check draw boundaries
  if Physics.x < 1+systems.cameraSystem.cameraX or
     Physics.x > self.horizontalTileMax+systems.cameraSystem.cameraX or 
     Physics.y < 1+systems.cameraSystem.cameraY or
     Physics.y > self.verticalTileMax+systems.cameraSystem.cameraY then 
     return
  end
  
  local xOffset, yOffset = 0, 0
  local rot = 0
  local sx, sy = 1, 1
  if Sprite.direction == "left" then
    yOffset = Sprite.size
    xOffset = Sprite.size
    --sx = -1
    rot = math.rad(180)
  elseif Sprite.direction == 'down' then
    rot = math.rad(90)
    xOffset = Sprite.size
  elseif Sprite.direction == 'up' then
    rot = math.rad(270)
    --xOffset = Sprite.size
    yOffset = Sprite.size
  end

  if Sprite.color then
    love.graphics.setColor(240,240,170)
  end
  --draw the sprite
  local pixelX = xOffset+(Physics.x-systems.cameraSystem.cameraX)*Sprite.size-Sprite.size
  local pixelY = yOffset+(Physics.y-systems.cameraSystem.cameraY)*Sprite.size-Sprite.size
  love.graphics.draw(Sprite.image,
    Sprite:getFrame(count),
    pixelX,
    pixelY,
    rot,
    sx*Sprite.size/16,
    sy*Sprite.size/16 )
  love.graphics.setColor(255,255,255)

  --draw a rectangle representing health
  if Physics.hp < Physics.maxHp then
    love.graphics.setColor(255,0,0,100)
    local lifeRatio = Physics.hp / Physics.maxHp
    love.graphics.rectangle( "fill", pixelX, pixelY+Sprite.size, Sprite.size*lifeRatio, 4)
    love.graphics.setColor(255,255,255,255)
  end
end

function SpriteSystem:addToLayer(entity)
  assert(entity.Physics.layer, "This entity needs a layer variable in Physics ->"..entity.id)
  if not self.layers[entity.Physics.layer] then
    self.layers[entity.Physics.layer] = {}
  end
  self.layers[entity.Physics.layer][entity.id] = entity
end

function SpriteSystem:removeFromLayer(entity)
  self.layers[entity.Physics.layer][entity.id] = nil
end

return SpriteSystem
