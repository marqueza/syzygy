local lovetoys = require "lib.lovetoys.lovetoys"
local function Goo(args)
	local entity = lovetoys.Entity()
	entity.name = "Goo"
	entity:add(Physics{x=args.x, y=args.y, blocks=true, layer="creature", plane=args.plane})
  entity:add(Stats{hp=5, str=1, dex=1, con=1})
	entity:add(Sprite{filename="img/sprites/goo.png"})
	entity:add(Faction{name="hostile"})
	return entity
end
return Goo
