require("../components/Position")
require("../components/Sprite")
require("../components/Block")
local Position, Sprite = Component.load({"Position", "Sprite"} )
local function Key(x, y)
	entity = Entity()
	entity:add(Position(x, y))
	entity:add(Sprite("img/sprites/key.png"))
	return entity
end
return Key