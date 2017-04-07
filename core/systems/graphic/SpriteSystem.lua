local SpriteSystem = class("SpriteSystem", System)
function SpriteSystem:initialize()
    System.initialize(self)
    self.maxCount = 4
end
function SpriteSystem:draw()
    local count = (math.floor(engine.time) % self.maxCount) + 1
    for i, v in pairs(self.targets) do
        local physics = v:get("physics")
        local sprite = v:get("sprite")

        love.graphics.draw(sprite.image,
            sprite:getFrame(count),
            0+physics.x*sprite.size-sprite.size,
            0+physics.y*sprite.size-sprite.size,
            0,
            4,
            4 )
    end
end

function SpriteSystem:update()

end
function SpriteSystem:requires()
    return {"physics", "sprite"}
end

return SpriteSystem
