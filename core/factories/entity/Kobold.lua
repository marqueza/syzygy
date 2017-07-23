local lovetoys = require "lib.lovetoys.lovetoys"
local function Kobold(args)
	local entity = lovetoys.Entity()
	entity.name = "Kobold"
	entity:add(Physics{x=args.x, y=args.y, hp=10, blocks=true})
	entity:add(Sprite{filename="img/sprites/kobold.png"})
	entity:add(Faction{name="hostile"})
	return entity
end
return Kobold
