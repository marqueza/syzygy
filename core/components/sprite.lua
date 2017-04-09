local sprite  = Component.create("sprite")

sprite.size = 64

function sprite:initialize(filename)
    if not game.options.headless then
        self.filename = filename
        self.image = love.graphics.newImage('res/' .. self.filename)
        self.image:setFilter("nearest", "nearest")
        local width = self.image:getWidth()
        local height = self.image:getHeight()
        self.frames = {}
        for i = 1, math.floor(width/height) do
            self.frames[i] = love.graphics.newQuad(i*height-height, 0, height, height, self.image:getWidth(), self.image:getHeight())
        end

    end
end

function sprite:getFrame(index)
    local i = (index) % table.getn(self.frames)
    return self.frames[i+1]
end
