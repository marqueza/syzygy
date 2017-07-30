local lovetoys = require "lib.lovetoys.lovetoys"
local function Brownie(args)
	local entity = lovetoys.Entity()
	entity.name = "Wood Sprite"
	entity:add(Physics{x=args.x, y=args.y, hp=50, blocks=true, layer = "character"})
	entity:add(Sprite{filename="img/sprites/brownie.png"})
	entity:add(Faction{name="ally"})
	entity:add(Ai{combatPreference="melee", idle="explore"})
	return entity
end
return Brownie
