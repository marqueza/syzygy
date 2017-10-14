local lovetoys = require "lib.lovetoys.lovetoys"
local function FairyQueen(args)
	local entity = lovetoys.Entity()
	entity.name = "fairy queen"
	entity:add(Physics{x=args.x, y=args.y, blocks=true, layer="creature", plane=args.plane})
  entity:add(Stats{hp=30, str=1, dex=4, con=1})
	entity:add(Sprite{filename="img/sprites/fairy_queen.png"})
	entity:add(Faction{name="hostile"})
  entity:add(Ai{combatPreference="melee", idle="still", objective="kill"})
	return entity
end
return FairyQueen
