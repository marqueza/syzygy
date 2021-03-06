local lovetoys = require 'lib.lovetoys.lovetoys'
local Sprite  = lovetoys.Component.create("Sprite")
local Serializable = require "data.serializable"
Sprite:include(Serializable)

Sprite.size = game.options.spriteSize

function Sprite:initialize(args)
  self.filename = args.filename
  self.direction = args.direction
  self.color = args.color

  if not game.options.headless then
    self:setImage(self.filename)
  end
end

function Sprite:getFrame(index)
  local i = (index) % table.getn(self.frames)
  return self.frames[i+1]
end

function Sprite:setImage(filename)
  self.image = love.graphics.newImage('res/' .. filename)
  self.image:setFilter("nearest", "nearest")
  self.isVisible = false
  local width = self.image:getWidth()
  local height = self.image:getHeight()
  self.frames = {}
  for i = 1, math.floor(width/height) do
    self.frames[i] = love.graphics.newQuad(i*height-height, 0, height, height, self.image:getWidth(), self.image:getHeight())
  end
end

return Sprite
