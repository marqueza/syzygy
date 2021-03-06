local lovetoys = require "lib.lovetoys.lovetoys"
local function Ghost(args)
	local entity = lovetoys.Entity()
	entity.name = "Ghost"
	entity:add(Physics{x=args.x, y=args.y, blocks=true, layer="creature", plane=args.plane})
  entity:add(Stats{hp=2, str=1, dex=2, con=1})
	entity:add(Sprite{filename="img/sprites/ghost.png"})
	entity:add(Faction{name="hostile"})
  entity:add(Ai{combatPreference="melee", idle="still", objective="kill"})
	return entity
end
return Ghost
