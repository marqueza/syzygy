local Factory = require("core/factories/entity/Factory")
local systems = require "core.systems.systems"

local arena = {}

function arena.build(seed, levelEvent)
    math.randomseed(seed)
    local options = options or {}
    arena.length = options.length or 10
    arena.width = options.width or 7
    local planeName = levelEvent.levelName..'-'..levelEvent.levelDepth

    --build basic map
    for i=1, arena.length do
        for j=1, arena.width do
            if i == 1 or i == arena.length or j == 1 or j == arena.width then
                if i == 1 and j ==1 then
                    systems.addEntity(Factory.Shore{x=i, y=j, direction="up", isCorner=true, plane=planeName})
                elseif i == arena.length and j == 1 then
                    systems.addEntity(Factory.Shore{x=i, y=j, direction="right", isCorner=true, plane=planeName})
                elseif i == 1 and j == arena.width then
                    systems.addEntity(Factory.Shore{x=i, y=j, direction="left", isCorner=true, plane=planeName})
                elseif i == arena.length and j == arena.width then
                    systems.addEntity(Factory.Shore{x=i, y=j, direction="down", isCorner=true, plane=planeName})
                elseif i == 1 then
                    systems.addEntity(Factory.Shore{x=i, y=j, direction="left", isCorner=false, plane=planeName})
                elseif i == arena.length then
                    systems.addEntity(Factory.Shore{x=i, y=j, direction="right", isCorner=false, plane=planeName})
                elseif j == 1 then
                    systems.addEntity(Factory.Shore{x=i, y=j, direction="up", isCorner=false, plane=planeName})
                elseif j == arena.width then
                    systems.addEntity(Factory.Shore{x=i, y=j, direction="down", isCorner=false, plane=planeName})
                end
            else
                --systems.addEntity(Factory.Grass{x=i, y=j, plane=planeName})
            end
            systems.planeSystem:setFloorSpace(i, j, planeName)
        end
    end

    systems.addEntity(Factory.Castle{x=2, y=2, plane=planeName})
    systems.addEntity(Factory.Cave{x=4, y=4, plane=planeName})
    systems.addEntity(Factory.Cave{x=3, y=4, plane=planeName})
    systems.addEntity(Factory.Cave{x=2, y=4, plane=planeName})
    systems.addEntity(Factory.Cave{x=4, y=3, plane=planeName})
    systems.addEntity(Factory.Cave{x=4, y=2, plane=planeName})
    systems.addEntity(Factory.Forest{x=5, y=5, plane=planeName})
    --set player
    if options.player then
        game.player = Factory.Player{x=3,y=3, plane=planeName}
        systems.addEntity(game.player)
    end
end

function arena.getRandX()
    return math.random(2, arena.length-1)
end

function arena.getRandY()
    return math.random(2, arena.width-1)
end

return arena
