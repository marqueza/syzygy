local lovetoys = require "lib.lovetoys.lovetoys"
local function Orc(args)
	local entity = lovetoys.Entity()
	entity.name = "orc"
	entity:add(Physics{x=args.x, y=args.y, hp=5, blocks=true, layer="creature"})
	entity:add(Sprite{filename="img/sprites/orc.png"})
	entity:add(Faction{name="hostile"})
	entity:add(Ai{combatPreference="melee", idle="still"})
	return entity
end
return Orc
