local lovetoys = require 'lib.lovetoys.lovetoys'
local sprite  = lovetoys.Component.create("sprite")
local Serializable = require "data.serializable"
sprite:include(Serializable)

sprite.size = 64

function sprite:initialize(args)
    if not game.options.headless then
        self.filename = args.filename
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
