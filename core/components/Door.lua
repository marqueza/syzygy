local lovetoys = require "lib.lovetoys.lovetoys"
local Door  = lovetoys.Component.create("Door")
local Serializable = require "data.serializable"
Door:include(Serializable)

function Door:initialize(args)
    self.isOpened = args.isOpened or false
    self.openSprite = args.openSprite
    self.closeSprite = args.closeSprite
end

function Door:open(entity)
  self.isOpened = true
  if entity.Physics then
    entity.Physics.blocks = false
  end
  if entity.Sprite then
    entity.Sprite.filename = self.openSprite
    entity.Sprite:setImage(self.openSprite)
  end
end

return Door
