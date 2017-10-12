local lovetoys = require "lib.lovetoys.lovetoys"
local function Golem(args)
	local entity = lovetoys.Entity()
	entity.name = "Golem"
	entity:add(Physics{x=args.x, y=args.y, blocks=true, plane=args.plane})
  entity:add(Stats{hp=10, str=1, dex=1, con=1})
	entity:add(Sprite{filename="img/sprites/golem.png"})
	entity:add(Faction{name="hostile"})
	return entity
end
return Golem
