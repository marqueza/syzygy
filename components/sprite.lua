local Sprite  = Component.create("Sprite")

Sprite.size = 64

function Sprite:initialize(filename)
    self.filename = filename
    self.image = love.graphics.newImage(self.filename)
    self.quad = love.graphics.newQuad(0, 0, 64, 64, self.image:getWidth(), self.image:getHeight())
end
