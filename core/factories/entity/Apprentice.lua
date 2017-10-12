local lovetoys = require "lib.lovetoys.lovetoys"
local function Apprentice(args)
	local entity = lovetoys.Entity()
	entity.name = "Apprentice"
	entity:add(Physics{x=args.x, y=args.y, blocks=true, plane=args.plane})
	entity:add(Sprite{filename="img/sprites/angel.png"})
	entity:add(Faction{name="ally"})
	return entity
end
return Apprentice
