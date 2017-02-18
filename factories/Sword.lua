require("../components/Position")
require("../components/Sprite")
local Position, Sprite = Component.load({"Position", "Sprite"} )
local function Heart(x, y)
	entity = Entity()
	entity:add(Position(x, y))
	entity:add(Sprite("img/sprites/heart.png"))
	return entity
end
return Heart