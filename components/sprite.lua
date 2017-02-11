local Sprite  = Component.create("Sprite")

Sprite.size = 64

function Sprite:initialize(filename)
    self.filename = filename
    self.image = love.graphics.newImage(self.filename)
    --self.quad = love.graphics.newQuad(0, 0, 64, 64, self.image:getWidth(), self.image:getHeight())
    local width = self.image:getWidth()
    self.frames = {}
    for i = 1, math.floor(width/64) do
        self.frames[i] = love.graphics.newQuad(i*64-64, 0, 64, 64, self.image:getWidth(), self.image:getHeight())
    end
end

function Sprite:getFrame(index)
    local i = (index) % table.getn(self.frames)
    return self.frames[i+1]
end
