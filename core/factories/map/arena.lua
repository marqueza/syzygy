local Factory = require("core/factories/entity/Factory")

local arena = {}

function arena.build(entityCallback, seed, options)
    math.randomseed(seed)
    local options = options or {}
    arena.length = options.length or 10
    arena.width = options.width or 7

    --root for level
    --local parent = entityCallback(Factory.Wall(1, 1))

    --build basic map
    for i=1, arena.length do
        for j=1, arena.width do
            if i == 1 or i == arena.length or j == 1 or j == arena.width then
                entityCallback(Factory.Wall{x=i, y=j, color=options.color})
            else
                entityCallback(Factory.Floor{x=i, y=j, color=options.color})
            end
        end
    end
    entityCallback(Factory.Upstairs{
        levelName = "tower",
        x=arena.getRandX(),
        y=arena.getRandY(),
        color=options.color})
    entityCallback(Factory.Downstairs{
        levelName = "tower",
        x=arena.getRandX(),
        y=arena.getRandY(),
        color=options.color})

    if not options.empty then

        if (math.random(0,1) == 1) then entityCallback(Factory.Orc{x=arena.getRandX(), y=arena.getRandY()}) end
        if (math.random(0,1) == 1) then entityCallback(Factory.Orc{x=arena.getRandX(), y=arena.getRandY()}) end
        if (math.random(0,1) == 1) then entityCallback(Factory.Orc{x=arena.getRandX(), y=arena.getRandY()}) end
        if (math.random(0,1) == 1) then entityCallback(Factory.Orc{x=arena.getRandX(), y=arena.getRandY()}) end
        --[[
        entityCallback(Factory.Goo{x=arena.getRandX(), y=arena.getRandY()})
        entityCallback(Factory.Fairy{x=arena.getRandX(), y=arena.getRandY()})
        entityCallback(Factory.Kobold{x=arena.getRandX(), y=arena.getRandY()})
        entityCallback(Factory.Golem{x=arena.getRandX(), y=arena.getRandY()})
        entityCallback(Factory.Brownie{x=arena.getRandX(), y=arena.getRandY()})
        --]]
    end

    --set player
    if options.spawnPlayer then
        game.player = Factory.Player{x=3,y=3}
        entityCallback(game.player)
    end
    if options.spawnMinion then
        game.player = Factory.Brownie{x=3,y=3}
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
