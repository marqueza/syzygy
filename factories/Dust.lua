require("../components/Position")
require("../components/Sprite")
require("../components/Block")
local Position, Sprite = Component.load({"Position", "Sprite"} )
local function Dust(x, y)
	entity = Entity()
	entity:add(Position(x, y))
	entity:add(Sprite("img/sprites/dust.png"))
	return entity
end
return Dust