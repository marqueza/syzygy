debug.debug()

-- Importing lovetoys
lovetoys = require("lib/lovetoys/lovetoys")
lovetoys.initialize({
    globals = true,
    debug = true
})
--Event Systems
CommandKeySystem = require("systems/event/CommandKeySystem")
MoveSystem = require("systems/event/MoveSystem")
MessageSystem = require("systems/event/MessageSystem")

--Draw Systems
SpriteSystem = require("systems/draw/SpriteSystem")

--Events
require("events/CommandKeyEvent")
require("events/MessageEvent")

--Factories
Factory = require("factories/Factory")

--map
Map = require("map/Map")
function love.load()
    --instances of engine and eventManager
	engine = Engine()
    eventManager = EventManager()
    time = 1
	
    --add draw systems to engine
	engine:addSystem(SpriteSystem())
	
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
    engine.messageLog = {"Welcome!"}

end

function love.update(dt)
    time = time + dt
    engine:update(dt)
end

function love.draw()
	engine:draw()
end

function love.keypressed(key)
    eventManager:fireEvent(CommandKeyEvent(key))
end