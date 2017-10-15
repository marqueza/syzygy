local lovetoys = require "lib.lovetoys.lovetoys"
local function Orc(args)
	local entity = lovetoys.Entity()
	entity.name = "orc"
	entity:add(Physics{x=args.x, y=args.y, blocks=true, layer="creature", plane=args.plane})
  entity:add(Stats{hp=8, str=2, dex=1, con=2})
	entity:add(Sprite{filename="img/sprites/orc.png"})
	entity:add(Faction{name="hostile"})
	entity:add(Ai{combatPreference="melee", idle="still", objective="kill"})
  entity:add(Flags{leavesCorpse=true})
	return entity
end
return Orc
