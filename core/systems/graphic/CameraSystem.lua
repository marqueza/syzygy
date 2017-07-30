local lovetoys = require "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local CameraSystem = class("CameraSystem", lovetoys.System)


function CameraSystem:initialize()
  lovetoys.System.initialize(self)
  --This is the camera's coordinates in spriteSize units
  self.cameraX = 1
  self.cameraY = 1
end


function CameraSystem:recenterCamera(entity)
    if entity and entity.Physics then 
      self.cameraX = entity.Physics.x-math.floor(systems.spriteSystem.horizontalTileMax/2)--game.options.spriteSize/2
      self.cameraY = entity.Physics.y-math.floor(systems.spriteSystem.verticalTileMax/2)--game.options.spriteSize/2
    elseif systems.infoBoxSystem.examinee then
      self.cameraX = systems.infoBoxSystem.examinee.Physics.x-math.floor(systems.spriteSystem.horizontalTileMax/2)
      self.cameraY = systems.infoBoxSystem.examinee.Physics.y-math.floor(systems.spriteSystem.verticalTileMax/2)
    end
end

return CameraSystem