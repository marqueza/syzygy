local Factory = require("core/factories/entity/Factory")

local arena = {}

function arena.build(entityCallback, seed, options)
    math.randomseed(seed)
    local options = options or {}
    arena.length = options.length or 10
    arena.width = options.width or 7

    --build basic map
    for i=1, arena.length do
        for j=1, arena.width do
            if i == 1 or i == arena.length or j == 1 or j == arena.width then
                if i == 1 and j ==1 then
                    entityCallback(Factory.Shore{x=i, y=j, direction="up", isCorner=true})
                elseif i == arena.length and j == 1 then
                    entityCallback(Factory.Shore{x=i, y=j, direction="right", isCorner=true})
                elseif i == 1 and j == arena.width then
                    entityCallback(Factory.Shore{x=i, y=j, direction="left", isCorner=true})
                elseif i == arena.length and j == arena.width then
                    entityCallback(Factory.Shore{x=i, y=j, direction="down", isCorner=true})
                elseif i == 1 then
                    entityCallback(Factory.Shore{x=i, y=j, direction="left", isCorner=false})
                elseif i == arena.length then
                    entityCallback(Factory.Shore{x=i, y=j, direction="right", isCorner=false})
                elseif j == 1 then
                    entityCallback(Factory.Shore{x=i, y=j, direction="up", isCorner=false})
                elseif j == arena.width then
                    entityCallback(Factory.Shore{x=i, y=j, direction="down", isCorner=false})
                end
            else
                entityCallback(Factory.Grass{x=i, y=j})
            end
        end
    end

    entityCallback(Factory.Castle{x=2, y=2})
    entityCallback(Factory.Cave{x=4, y=4})
    --set player
    if options.player then
        game.player = Factory.Player{x=3,y=3}
        entityCallback(game.player)
    end
end

function arena.getRandX()
    return math.random(2, arena.length-1)
end

function arena.getRandY()
    return math.random(2, arena.width-1)
end

return arena
