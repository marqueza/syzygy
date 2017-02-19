require("../components/Position")
require("../components/Sprite")
local Position, Sprite = Component.load({"Position", "Sprite"} )
local function Spear(x, y)
	entity = Entity()
	entity:add(Position(x, y))
	entity:add(Sprite("img/sprites/spear.png"))
	return entity
end
return Spear
