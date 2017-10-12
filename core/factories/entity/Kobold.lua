local lovetoys = require "lib.lovetoys.lovetoys"
local function Kobold(args)
	local entity = lovetoys.Entity()
	entity.name = "Kobold"
	entity:add(Physics{x=args.x, y=args.y, blocks=true, plane=args.plane})
  entity:add(Stats{hp=2, str=1, dex=2, con=1})
	entity:add(Sprite{filename="img/sprites/kobold.png"})
	entity:add(Faction{name="hostile"})
	return entity
end
return Kobold
