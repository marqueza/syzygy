require("../components/Position")
require("../components/Sprite")
require("../components/Block")
local Position, Sprite, Block = Component.load({"Position", "Sprite", "Block"})

local function Wall(x, y)
	entity = Entity()
	entity:add(Position(x, y))
	entity:add(Sprite("img/sprites/wall.png"))
	entity:add(Block())
	return entity
end
return Wall
