local lovetoys = require "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local SpriteSystem = class("SpriteSystem", lovetoys.System)

function SpriteSystem:initialize()
    love.window.setMode(1280,720)
    love.graphics.setNewFont("res/font/Pixeled.ttf", 10)
    lovetoys.System.initialize(self)
    self.maxCount = 4
end
function SpriteSystem:draw()
    local count = (math.floor(game.time) % self.maxCount) + 1
    for i, v in pairs(self.targets) do
        local Physics = v:get("Physics")
        local Sprite = v:get("Sprite")

        love.graphics.draw(Sprite.image,
            Sprite:getFrame(count),
            0+Physics.x*Sprite.size-Sprite.size,
            0+Physics.y*Sprite.size-Sprite.size,
            0,
            4,
            4 )
    end
end

function SpriteSystem:update()

end
function SpriteSystem:requires()
    return {"Physics", "Sprite"}
end

return SpriteSystem
