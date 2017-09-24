local lovetoys = require "lib.lovetoys.lovetoys"
local function Skeleton(args)
	local entity = lovetoys.Entity()
  entity.name = "skeleton"
	entity:add(Physics{x=args.x, y=args.y, hp=5, blocks=true, layer="creature", plane=args.plane})
	entity:add(Sprite{filename="img/sprites/skeleton.png"})
	entity:add(Faction{name="hostile"})
	entity:add(Ai{combatPreference="melee", idle="still", objective="kill"})
	return entity
end
return Skeleton