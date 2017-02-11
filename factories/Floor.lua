require("../components/Position")
require("../components/Sprite")
local Position, Sprite, Block = Component.load({"Position", "Sprite"})

local function Floor(x, y)
	entity = Entity()
	entity:add(Position(x, y))
	entity:add(Sprite("img/sprites/floor.png"))
	return entity
end
return Floor
