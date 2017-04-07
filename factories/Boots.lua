require("../components/Position")
require("../components/Sprite")
local Position, Sprite = Component.load({"Position", "Sprite"} )
local function Boots(x, y)
	entity = Entity()
	entity:add(Position(x, y))
	entity:add(Sprite("img/sprites/boots.png"))
	return entity
end
return Boots
