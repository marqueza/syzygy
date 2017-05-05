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
                    entityCallback(Factory.Shore(i, j, "up", true))
                elseif i == arena.length and j == 1 then
                    entityCallback(Factory.Shore(i, j, "right", true))
                elseif i == 1 and j == arena.width then
                    entityCallback(Factory.Shore(i, j, "left", true))
                elseif i == arena.length and j == arena.width then
                    entityCallback(Factory.Shore(i, j, "down", true))
                elseif i == 1 then
                    entityCallback(Factory.Shore(i, j, "left"))
                elseif i == arena.length then
                    entityCallback(Factory.Shore(i, j, "right"))
                elseif j == 1 then
                    entityCallback(Factory.Shore(i, j, "up"))
                elseif j == arena.width then
                    entityCallback(Factory.Shore(i, j, "down"))
                end
            else
                entityCallback(Factory.Grass(i, j))
            end
        end
    end

    entityCallback(Factory.Castle(2, 2))
    entityCallback(Factory.Cave(4, 4))
    --set player
    if options.player then
        game.player = Factory.Player(3,3)
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
