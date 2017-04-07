-- Importing lovetoys
lovetoys = require "lib/lovetoys/lovetoys"
lovetoys.initialize({
    globals = true,
    debug = true
})
--Event Systems
CommandKeySystem = require("core/systems/event/CommandKeySystem")
MoveSystem = require("core/systems/event/MoveSystem")
MessageSystem = require("core/systems/event/MessageSystem")

--Graphic Systems(update and draw)
SpriteSystem = require("core/systems/graphic/SpriteSystem")
PromptSystem = require("core/systems/graphic/PromptSystem")

--Events
require("core/events/CommandKeyEvent")
require("core/events/MessageEvent")

--Factories
local EntityFactory = require("core/factories/entity/EntityFactory")
local Map = require("core/factories/map/Map")


function love.load()
--graphic settings
--love.graphics.setNewFont(love.filesystem.getWorkingDirectory() .. "/res/font/Pixeled.ttf", 16)
love.graphics.setNewFont("res/font/Pixeled.ttf", 10)

  if arg[#arg] == "-debug" then require("mobdebug").start() end
    love.window.setMode(1280,720)
    --instances of engine and eventManager

    engine = Engine()

    --shared info between systems
    engine.time = 1
    engine.turn = 1
    engine.log = {"", ""}

    --required for events
    eventManager = EventManager()

    --add draw systems to engine
    engine:addSystem(SpriteSystem(), "draw")
    engine:addSystem(SpriteSystem(), "update")
    engine:addSystem(PromptSystem(), "draw")
    engine:addSystem(PromptSystem(), "update")

    --instances of event systems
    moveSystem = MoveSystem()
    commandKeySystem = CommandKeySystem()
    messageSystem = MessageSystem()

    --register listeners
    eventManager:addListener("CommandKeyEvent", commandKeySystem, commandKeySystem.fireEvent)
    eventManager:addListener("MoveEvent", moveSystem, moveSystem.fireEvent)
    eventManager:addListener("MessageEvent", messageSystem, messageSystem.fireEvent)

    --add entity to engine
    Map.Build.Arena()
    engine:addEntity(EntityFactory.Player(3, 3))
end

function love.update(dt)
    engine.time = engine.time + dt
    engine:update(dt)
end

function love.draw()
    love.graphics.setColor(255, 255, 255)
    engine:draw()
    love.graphics.setColor(255, 0, 0)
    love.graphics.setColor(255, 255, 255)
end

function love.keypressed(key)
    eventManager:fireEvent(CommandKeyEvent(key))
end
