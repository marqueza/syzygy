-- Importing lovetoys
lovetoys = require("lib/lovetoys/lovetoys")
lovetoys.initialize({
    globals = true,
    debug = true
})

--draw systems
SpriteDrawSystem = require("systems/sprite_draw_system")
require("factories/wall")
require("factories/goo")

function love.load()
	engine = Engine()
	
	engine:addSystem(SpriteDrawSystem())
	
	engine:addEntity(Wall(1,1))
	engine:addEntity(Wall(1,2))
	engine:addEntity(Wall(1,3))
	engine:addEntity(Wall(3,1))
	engine:addEntity(Wall(3,2))
	engine:addEntity(Wall(3,3))
	engine:addEntity(Wall(3,4))
	engine:addEntity(Goo(2,1))
end

function love.update(dt)
    engine:update(dt)
end

function love.draw()
	engine:draw()
end
