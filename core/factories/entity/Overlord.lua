local lovetoys = require "lib.lovetoys.lovetoys"
local function Overlord(args)
	local entity = lovetoys.Entity()
	entity.name = "overlord"
	entity:add(Physics{x=args.x, y=args.y, blocks=true, layer="creature", plane=args.plane})
  entity:add(Stats{hp=30, str=2, dex=1, con=1})
	entity:add(Sprite{filename="img/sprites/overlord.png"})
	entity:add(Faction{name="hostile"})
	entity:add(Ai{combatPreference="melee", idle="still", objective="kill"})
  entity:add(Flags{leavesCorpse=true})
	return entity
end
return Overlord
