local SpriteDrawSystem = class("SpriteDrawSystem", System)
function SpriteDrawSystem:initialize()
    System.initialize(self)
    self.maxCount = 4
end
function SpriteDrawSystem:draw()
    local count = (math.floor(time) % self.maxCount) + 1
    for i, v in pairs(self.targets) do
        local position = v:get("Position")
        local sprite = v:get("Sprite")
        love.graphics.draw(sprite.image, 
            sprite:getFrame(count), 
            engine.ui.gameBox.frame.x+position.x*sprite.size-sprite.size, 
            engine.ui.gameBox.frame.y+position.y*sprite.size-sprite.size,
            0,
            4,
            4 )
    end
end

function SpriteDrawSystem:update()

end
function SpriteDrawSystem:requires()
    return {"Position", "Sprite"}
end

return SpriteDrawSystem
