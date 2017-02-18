require("../components/Position")
require("../components/Sprite")
local Position, Sprite = Component.load({"Position", "Sprite"} )
local function Sword(x, y)
	entity = Entity()
	entity:add(Position(x, y))
	entity:add(Sprite("img/sprites/sword.png"))
	return entity
end
return Sword