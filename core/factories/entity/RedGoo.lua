local lovetoys = require "lib.lovetoys.lovetoys"
local function RedGoo(args)
	local entity = lovetoys.Entity()
	entity.name = "Red Goo"
	entity:add(Physics{x=args.x, y=args.y, blocks=true, layer="creature", plane=args.plane})
  entity:add(Stats{hp=40, str=3, dex=1, con=3})
	entity:add(Sprite{filename="img/sprites/red_goo.png"})
	entity:add(Faction{name="hostile"})
  entity:add(Ai{combatPreference="melee", idle="still", objective="kill"})
	return entity
end

return RedGoo

