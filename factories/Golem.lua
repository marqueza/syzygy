require("../components/Position")
require("../components/Sprite")
require("../components/Block")
require("../components/Control")
local Position, Sprite, Block, Control = Component.load({"Position", "Sprite", "Block"})
local function Golem(x, y)
	entity = Entity()
	entity:add(Position(x, y))
	entity:add(Sprite("img/sprites/golem.png"))
	entity:add(Block())
	return entity
end
return Golem