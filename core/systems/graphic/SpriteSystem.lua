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
local _drawStructures

function SpriteSystem:draw()
  self:drawLayer("structure")
  self:drawLayer("backdrop")
  self:drawLayer("item")
  self:drawLayer("creature")
end

function SpriteSystem:update()

end
function SpriteSystem:requires()
  return {"Physics", "Sprite"}
end

_drawStructures = function(self)
  local knownTable = systems.planeSystem.planes[game.player.Physics.plane]["known"]
  local visibleTable = systems.planeSystem.planes[game.player.Physics.plane]["visible"]
  local floorTable = systems.planeSystem.planes[game.player.Physics.plane]["structure"]
  if floorTable then 
    for knownCoord, isKnown in pairs(knownTable) do
      if isKnown then
        --extract the coord
        local strings = string.gmatch(knownCoord, "%d+")
        local x = tonumber(strings())
        local y = tonumber(strings())

        if not( x < 1+systems.cameraSystem.cameraX or
          x > self.horizontalTileMax+systems.cameraSystem.cameraX or 
          y < 1+systems.cameraSystem.cameraY or
          y > self.verticalTileMax+systems.cameraSystem.cameraY )then 
          
          if systems.planeSystem:isVisibleSpace(x, y, game.player.Physics.plane) then
            if systems.planeSystem:isFloorSpace(x, y, game.player.Physics.plane) then
              love.graphics.setColor(150,150,150,255)
            else
              love.graphics.setColor(100,100,100,255)
            end
          else
            if systems.planeSystem:isFloorSpace(x, y, game.player.Physics.plane) then
              love.graphics.setColor(90,90,90,255)
            else
              love.graphics.setColor(40,40,40,255)
            end
          end
            
          
          love.graphics.rectangle( "fill", 
            (x-1-systems.cameraSystem.cameraX)*game.options.spriteSize, 
            (y-1-systems.cameraSystem.cameraY)*game.options.spriteSize, 
            game.options.spriteSize, 
            game.options.spriteSize)
          love.graphics.setColor(255,255,255,255)
          end
        end
      end
    end
  end

  _drawSprite = function(self, spriteEntity, count)
    local Physics = spriteEntity:get("Physics")
    local Sprite = spriteEntity:get("Sprite")
    if not systems.planeSystem:isKnownSpace(spriteEntity.Physics.x, spriteEntity.Physics.y, spriteEntity.Physics.plane) then
      return
    end
    if not systems.planeSystem:isVisibleSpace(spriteEntity.Physics.x, spriteEntity.Physics.y, spriteEntity.Physics.plane) then
      if spriteEntity.Faction then return end
      love.graphics.setColor(150, 150, 150)
    else
      love.graphics.setColor(255,255,255,255)
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
     love.graphics.setColor(255,255,255,255)
  end

  function SpriteSystem:drawLayer(layerName)
    local count = (math.floor(game.time) % self.maxCount) + 1
    local layer = systems.planeSystem.planes[game.player.Physics.plane][layerName]
    if layerName == "structure" then
      _drawStructures(self)
    elseif layer then
      for key, entityList  in pairs(layer) do
        for k, spriteEntity in pairs(entityList) do
          _drawSprite(self, spriteEntity, count)
        end
      end
    end
  end

  return SpriteSystem
