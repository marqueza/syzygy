local Factory = require("core/factories/entity/Factory")
local systems = require "core.systems.systems"

local lair = {}

function lair.build(seed, levelEvent)
    math.randomseed(seed)
    local options = levelEvent.options
    lair.length = 30
    lair.width = 30
    local planeName = levelEvent.levelName .. "-" .. levelEvent.levelDepth

    --build basic map
    for i=1, lair.length do
        for j=1, lair.width do
            if i == 1 or i == lair.length or j == 1 or j == lair.width then
                systems.addEntity(Factory.Wall{
                    x=i, 
                    y=j, 
                    color=options.color, 
                    plane=planeName})
            else
            end
        end
    end
    
    
    if levelEvent.levelDepth <= 1 then
       systems.addEntity(Factory.OutsideEntrance{
        levelName = "overWorld",
        x=lair.getRandX(),
        y=lair.getRandY(),
        color=options.color,
        plane=planeName})
    else
      
    systems.addEntity(Factory.Upstairs{
        levelName = levelEvent.levelName,
        x=lair.getRandX(),
        y=lair.getRandY(),
        color=options.color,
        plane=planeName})
    end
    
    if levelEvent.levelDepth < 3 then
        systems.addEntity(Factory.Downstairs{
            levelName = levelEvent.levelName,
            x=lair.getRandX(),
            y=lair.getRandY(),
            color=options.color,
            plane=planeName})
    else
      local boss = Factory.Overlord{x=lair.getRandX(), y=lair.getRandY(), plane=planeName}
      boss:add(components.Boss{})
      systems.addEntity(boss)
      systems.addEntity(Factory.DragonEgg{x=lair.getRandX(), y=lair.getRandY()})
      end

    if not options.empty then

    end

    --set player
    if options.spawnPlayer then
        game.player = Factory.Player{x=3,y=3,plane=planeName}
        systems.addEntity(game.player)
    end
    if options.spawnMinion then
        game.player = Factory.Brownie{x=3,y=3,plane=planeName}
        systems.addEntity(game.player)
    end
end

function lair.getRandX()
    return math.random(2, lair.length-1)
end

function lair.getRandY()
    return math.random(2, lair.width-1)
end

return lair
