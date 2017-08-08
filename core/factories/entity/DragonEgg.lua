local lovetoys = require "lib.lovetoys.lovetoys"
local function DragonEgg(args)
	local entity = lovetoys.Entity()
	entity.name = "dragon egg"
	entity:add(Physics{x=args.x, y=args.y, hp=50, blocks=true, layer="creature", plane=args.plane})
  entity:add(Faction{name="ally"})
	entity:add(Sprite{filename="img/sprites/dragon_egg.png"})
	return entity
end
return DragonEgg
