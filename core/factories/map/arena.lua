local Factory = require("core/factories/entity/EntityFactory")

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
                entityCallback(Factory.Wall(i, j))
            else
                entityCallback(Factory.Floor(i, j))
            end
        end
    end

    if not options.empty then

        entityCallback(Factory.Orc(arena.getRandX(), arena.getRandY()))
        entityCallback(Factory.Orc(arena.getRandX(), arena.getRandY()))
        entityCallback(Factory.Orc(arena.getRandX(), arena.getRandY()))
        entityCallback(Factory.Orc(arena.getRandX(), arena.getRandY()))
    end

    --set player
    game.player = Factory.Player(3,3)
    entityCallback(game.player)
end

function arena.getRandX()
    return math.random(2, arena.length-1)
end

function arena.getRandY()
    return math.random(2, arena.width-1)
end

return arena
