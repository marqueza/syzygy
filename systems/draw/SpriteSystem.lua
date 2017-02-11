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
        love.graphics.draw(sprite.image, sprite:getFrame(count), position.x*sprite.size, position.y*sprite.size)
    end
end


function SpriteDrawSystem:requires()
    return {"Position", "Sprite"}
end

return SpriteDrawSystem
