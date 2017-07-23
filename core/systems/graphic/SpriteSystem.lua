local lovetoys = require "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local SpriteSystem = class("SpriteSystem", lovetoys.System)

function SpriteSystem:initialize()
    love.window.setMode(1280,720)
    local font = love.graphics.setNewFont("res/font/tamsyn_bold.pcf", 16)
    font:setFilter("nearest", "nearest")
    lovetoys.System.initialize(self)
    self.maxCount = 4
end
function SpriteSystem:draw()
    local count = (math.floor(game.time) % self.maxCount) + 1
    for i, v in pairs(self.targets) do
        local Physics = v:get("Physics")
        local Sprite = v:get("Sprite")

        local xOffset, yOffset = 0, 0
        local rot = 0
        local sx, sy = 1, 1
        if Sprite.direction == "left" then
            yOffset = Sprite.size
            xOffset = Sprite.size
            --sx = -1
            rot = math.rad(180)
        elseif Sprite.direction == 'down' then
            rot = math.rad(90)
            xOffset = Sprite.size
        elseif Sprite.direction == 'up' then
            rot = math.rad(270)
            --xOffset = Sprite.size
            yOffset = Sprite.size
        end

        if Sprite.color then
                love.graphics.setColor(240,240,170)
        end
        --draw the sprite
        local pixelX = xOffset+Physics.x*Sprite.size-Sprite.size
        local pixelY = yOffset+Physics.y*Sprite.size-Sprite.size
        love.graphics.draw(Sprite.image,
            Sprite:getFrame(count),
            pixelX,
            pixelY,
            rot,
            sx*Sprite.size/16,
            sy*Sprite.size/16 )
        love.graphics.setColor(255,255,255)

        --draw a rectangle representing health
        if Physics.hp < Physics.maxHp then
            love.graphics.setColor(255,0,0,100)
            local lifeRatio = Physics.hp / Physics.maxHp
            love.graphics.rectangle( "fill", pixelX, pixelY+Sprite.size, Sprite.size*lifeRatio, 4)
            love.graphics.setColor(255,255,255,255)
        end

    end
end

function SpriteSystem:update()

end
function SpriteSystem:requires()
    return {"Physics", "Sprite"}
end

return SpriteSystem
