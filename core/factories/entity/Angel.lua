local lovetoys = require "lib.lovetoys.lovetoys"
local function Angel(args)
	entity = lovetoys.Entity()
	entity.name = "angel"
	entity:add(Faction("neutral"))
  entity:add(Physics{x=args.x, y=args.y, blocks=true, layer="creature", plane=args.plane})
  entity:add(Stats{hp=50, str=1, dex=1, con=1})
	entity:add(Sprite{filename="img/sprites/angel.png"})
	return entity
end
return Angel
