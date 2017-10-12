local lovetoys = require "lib.lovetoys.lovetoys"
local function Ghost(args)
	local entity = lovetoys.Entity()
	entity.name = "Ghost"
	entity:add(Physics{x=args.x, y=args.y, blocks=true, plane=args.plane})
  entity:add(Stats{hp=2, str=1, dex=1, con=1})
	entity:add(Sprite{filename="img/sprites/ghost.png"})
	entity:add(Faction{name="ally"})
	return entity
end
return Ghost
