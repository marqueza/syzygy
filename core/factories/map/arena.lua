local Factory = require("core/factories/entity/Factory")
local systems = require "core.systems.systems"

local arena = {}

function arena.build(seed, levelEvent)
    math.randomseed(seed)
    local options = levelEvent.options
    arena.length = options.length or 10
    arena.width = options.width or 7

    --root for level
    --local parent = systems.addEntity(Factory.Wall(1, 1))

    --build basic map
    for i=1, arena.length do
        for j=1, arena.width do
            if i == 1 or i == arena.length or j == 1 or j == arena.width then
                systems.addEntity(Factory.Wall{x=i, y=j, color=options.color})
            else
                systems.addEntity(Factory.Floor{x=i, y=j, color=options.color})
            end
        end
    end
    
    
    if levelEvent.levelDepth <= 1 then
       systems.addEntity(Factory.OutsideEntrance{
        levelName = "overWorld",
        x=arena.getRandX(),
        y=arena.getRandY(),
        color=options.color})
    else
      
    systems.addEntity(Factory.Upstairs{
        levelName = levelEvent.levelName,
        x=arena.getRandX(),
        y=arena.getRandY(),
        color=options.color})
    end
    
    if levelEvent.levelDepth < 10 then
        systems.addEntity(Factory.Downstairs{
            levelName = levelEvent.levelName,
            x=arena.getRandX(),
            y=arena.getRandY(),
            color=options.color})
    else
      systems.addEntity(Factory.Medal{x=arena.getRandX(), y=arena.getRandY()})
      end

    if not options.empty then

        if (math.random(0,1) == 1) then systems.addEntity(Factory.Orc{x=arena.getRandX(), y=arena.getRandY()}) end
        if (math.random(0,1) == 1) then systems.addEntity(Factory.Orc{x=arena.getRandX(), y=arena.getRandY()}) end
        if (math.random(0,1) == 1) then systems.addEntity(Factory.Orc{x=arena.getRandX(), y=arena.getRandY()}) end
        if (math.random(0,1) == 1) then systems.addEntity(Factory.Orc{x=arena.getRandX(), y=arena.getRandY()}) end
        --[[
        systems.addEntity(Factory.Goo{x=arena.getRandX(), y=arena.getRandY()})
        systems.addEntity(Factory.Fairy{x=arena.getRandX(), y=arena.getRandY()})
        systems.addEntity(Factory.Kobold{x=arena.getRandX(), y=arena.getRandY()})
        systems.addEntity(Factory.Golem{x=arena.getRandX(), y=arena.getRandY()})
        systems.addEntity(Factory.Brownie{x=arena.getRandX(), y=arena.getRandY()})
        --]]
    end

    --set player
    if options.spawnPlayer then
        game.player = Factory.Player{x=3,y=3}
        systems.addEntity(game.player)
    end
    if options.spawnMinion then
        game.player = Factory.Brownie{x=3,y=3}
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
