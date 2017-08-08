local Factory = require("core/factories/entity/Factory")
local systems = require "core.systems.systems"

local arena = {}

function arena.build(seed, levelEvent)
    math.randomseed(seed)
    local options = levelEvent.options
    local planeName = levelEvent.levelName..'-'..levelEvent.levelDepth
    arena.length = options.length or 10
    arena.width = options.width or 7

    --root for level
    --local parent = systems.addEntity(Factory.Wall(1, 1))

    --build basic map
    for i=1, arena.length do
        for j=1, arena.width do
            if i == 1 or i == arena.length or j == 1 or j == arena.width then
                systems.addEntity(Factory.Wall{x=i, y=j, color=options.color, plane=planeName})
            else
                --systems.addEntity(Factory.Floor{x=i, y=j, color=options.color, plane=planeName})
            end
        end
    end
    
    
    if levelEvent.levelDepth <= 1 then
       systems.addEntity(Factory.OutsideEntrance{
        levelName = "overWorld",
        x=arena.getRandX(),
        y=arena.getRandY(),
        color=options.color,
        plane=planeName})
    else
      
    systems.addEntity(Factory.Upstairs{
        levelName = levelEvent.levelName,
        x=arena.getRandX(),
        y=arena.getRandY(),
        color=options.color,
        plane=planeName})
    end
    
    if levelEvent.levelDepth < 3 then
        systems.addEntity(Factory.Downstairs{
            levelName = levelEvent.levelName,
            x=arena.getRandX(),
            y=arena.getRandY(),
            color=options.color,
            plane=planeName})
    else
      systems.addEntity(Factory.Medal{x=arena.getRandX(), y=arena.getRandY(), plane=planeName})
      systems.addEntity(Factory.DragonEgg{x=arena.getRandX(), y=arena.getRandY(), plane=planeName})
      end

    if not options.empty then

        if (math.random(0,1) == 1) then systems.addEntity(Factory.Orc{x=arena.getRandX(), y=arena.getRandY(), plane=planeName}) end
        if (math.random(0,1) == 1) then systems.addEntity(Factory.Orc{x=arena.getRandX(), y=arena.getRandY(), plane=planeName}) end
        if (math.random(0,1) == 1) then systems.addEntity(Factory.Orc{x=arena.getRandX(), y=arena.getRandY(), plane=planeName}) end
        if (math.random(0,1) == 1) then systems.addEntity(Factory.Orc{x=arena.getRandX(), y=arena.getRandY(), plane=planeName}) end
        if (math.random(0,1) == 1) then systems.addEntity(Factory.Overlord{x=arena.getRandX(), y=arena.getRandY(), plane=planeName}) end

    end

    --set player
    if options.spawnPlayer then
        game.player = Factory.Player{x=3,y=3, plane=planeName}
        systems.addEntity(game.player)
    end
    if options.spawnMinion then
        game.player = Factory.Brownie{x=3,y=3, plane=planeName}
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
