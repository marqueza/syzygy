local lovetoys = require "lib.lovetoys.lovetoys"
local function DragonEgg(args)
	local entity = lovetoys.Entity()
	entity.name = "dragon egg"
	entity:add(Physics{x=args.x, y=args.y, blocks=true, layer="creature", plane=args.plane})
  entity:add(Stats{hp=50, str=1, dex=1, con=1})
  entity:add(Faction{name="ally"})
	entity:add(Sprite{filename="img/sprites/dragon_egg.png"})
	return entity
end
return DragonEgg
