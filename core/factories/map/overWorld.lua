local Factory = require("core/factories/entity/Factory")
local systems = require "core.systems.systems"

local arena = {}

function arena.build(seed, levelEvent)
    math.randomseed(seed)
    local options = options or {}
    arena.length = options.length or 10
    arena.width = options.width or 7

    --build basic map
    for i=1, arena.length do
        for j=1, arena.width do
            if i == 1 or i == arena.length or j == 1 or j == arena.width then
                if i == 1 and j ==1 then
                    systems.addEntity(Factory.Shore{x=i, y=j, direction="up", isCorner=true})
                elseif i == arena.length and j == 1 then
                    systems.addEntity(Factory.Shore{x=i, y=j, direction="right", isCorner=true})
                elseif i == 1 and j == arena.width then
                    systems.addEntity(Factory.Shore{x=i, y=j, direction="left", isCorner=true})
                elseif i == arena.length and j == arena.width then
                    systems.addEntity(Factory.Shore{x=i, y=j, direction="down", isCorner=true})
                elseif i == 1 then
                    systems.addEntity(Factory.Shore{x=i, y=j, direction="left", isCorner=false})
                elseif i == arena.length then
                    systems.addEntity(Factory.Shore{x=i, y=j, direction="right", isCorner=false})
                elseif j == 1 then
                    systems.addEntity(Factory.Shore{x=i, y=j, direction="up", isCorner=false})
                elseif j == arena.width then
                    systems.addEntity(Factory.Shore{x=i, y=j, direction="down", isCorner=false})
                end
            else
                systems.addEntity(Factory.Grass{x=i, y=j})
            end
        end
    end

    systems.addEntity(Factory.Castle{x=2, y=2})
    systems.addEntity(Factory.Cave{x=4, y=4})
    --set player
    if options.player then
        game.player = Factory.Player{x=3,y=3}
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
