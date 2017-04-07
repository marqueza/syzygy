-- Importing lovetoys
lovetoys = require("lib/lovetoys/lovetoys")
lovetoys.initialize({
    globals = true,
    --debug = true
})

--Importing thranduil UI lib
UI = require 'lib.UI'

--Event Systems
CommandKeySystem = require("systems/event/CommandKeySystem")
MoveSystem = require("systems/event/MoveSystem")
MessageSystem = require("systems/event/MessageSystem")

--Graphic Systems(update and draw)
SpriteSystem = require("systems/graphic/SpriteSystem")

--Events
require("events/CommandKeyEvent")
require("events/MessageEvent")

--Factories
Factory = require("factories/Factory")

--map
Map = require("map/Map")


--ui
GameBox = require("ui/GameBox")
MessageBox = require("ui/MessageBox")
function love.load()
    love.window.setMode(1280,720)
    --instances of engine and eventManager
    UI.registerEvents()

    engine = Engine()
    eventManager = EventManager()
    time = 1

    --add draw systems to engine
    engine:addSystem(SpriteSystem(), "draw")
    engine:addSystem(SpriteSystem(), "update")

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
    engine:addEntity(Factory.Player(3, 3))

    engine.state = "decision"
    engine.turn = 1
    engine.messageTable = {"Welcome!"}

    engine.ui = {}
    engine.ui.gameBox = GameBox(0, 0, 10*64, 7*64 )
    engine.ui.messageBox = MessageBox(
        0, 
        engine.ui.gameBox.frame.y+engine.ui.gameBox.frame.h, 
        engine.ui.gameBox.frame.w, 
        4*64 )

end

function love.update(dt)
    time = time + dt
    engine:update(dt)
    --ui elements
    for k, v in pairs(engine.ui) do
        v:update(dt)
    end
end

function love.draw()
    --ui elements
    for k, v in pairs(engine.ui) do
        v:draw()
    end
    love.graphics.setColor(255, 255, 255)
    engine:draw()
    love.graphics.setColor(255, 0, 0)
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("x:" .. engine.ui.gameBox.frame.x .. " y:" .. engine.ui.gameBox.frame.y, 10, 200)
end

function love.keypressed(key)
    eventManager:fireEvent(CommandKeyEvent(key))
end
