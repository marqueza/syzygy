local lovetoys = require "lib.lovetoys.lovetoys"
local function Overlord(args)
	local entity = lovetoys.Entity()
	entity.name = "overlord"
	entity:add(Physics{x=args.x, y=args.y, hp=35, blocks=true, layer="character"})
	entity:add(Sprite{filename="img/sprites/overlord.png"})
	entity:add(Faction{name="hostile"})
	entity:add(Ai{combatPreference="melee", idle="still"})
	return entity
end
return Overlord
