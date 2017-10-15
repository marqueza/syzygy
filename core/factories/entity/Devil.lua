local lovetoys = require "lib.lovetoys.lovetoys"
local function Devil(args)
	entity = lovetoys.Entity()
	entity.name = "devil"
	entity:add(Faction("neutral"))
  entity:add(Physics{x=args.x, y=args.y, blocks=true, layer="creature", plane=args.plane})
  entity:add(Stats{hp=3, str=1, dex=1, con=1})
  entity:add(Ai{combatPreference="melee", idle="still", objective="kill"})
	entity:add(Sprite{filename="img/sprites/devil.png"})
	return entity
end
return Devil
