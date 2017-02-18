require("../components/Position")
require("../components/Sprite")
require("../components/Block")
require("../components/Control")
local Position, Sprite, Block, Control = Component.load({"Position", "Sprite", "Block"})
local function Angel(x, y)
	entity = Entity()
	entity:add(Position(x, y))
	entity:add(Sprite("img/sprites/angel.png"))
	entity:add(Block())
	return entity
end
return Angel