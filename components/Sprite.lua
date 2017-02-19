local Sprite  = Component.create("Sprite")

Sprite.size = 64

function Sprite:initialize(filename)
    self.filename = filename
    self.image = love.graphics.newImage(self.filename)
    self.image:setFilter("nearest", "nearest")
    local width = self.image:getWidth()
    local height = self.image:getHeight()
    self.frames = {}
    for i = 1, math.floor(width/height) do
        self.frames[i] = love.graphics.newQuad(i*height-height, 0, height, height, self.image:getWidth(), self.image:getHeight())
    end
end

function Sprite:getFrame(index)
    local i = (index) % table.getn(self.frames)
    return self.frames[i+1]
end
