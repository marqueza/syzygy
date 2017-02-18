require("../components/Position")
require("../components/Sprite")
local Position, Sprite = Component.load({"Position", "Sprite"} )
local function Goop(x, y)
	entity = Entity()
	entity:add(Position(x, y))
	entity:add(Sprite("img/sprites/goop.png"))
	return entity
end
return Goop