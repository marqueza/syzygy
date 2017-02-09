local SpriteDrawSystem = class("SpriteDrawSystem", System)

function SpriteDrawSystem:draw()
    for i, v in pairs(self.targets) do
        local position = v:get("Position")
        local sprite = v:get("Sprite")
        love.graphics.draw(sprite.image, sprite.quad, position.x*sprite.size, position.y*sprite.size)
    end
end

function SpriteDrawSystem:requires()
    return {"Position", "Sprite"}
end

return SpriteDrawSystem
