require("../components/position")
require("../components/sprite")
require("../components/block")
local Position, Sprite, Block = Component.load({"Position", "Sprite", "Block"})
function Wall(x, y)
	entity = Entity()
	entity:add(Position(x, y))
	entity:add(Sprite("img/sprites/wall.png"))
	entity:add(Block())
	return entity
end
