local lovetoys = require "lib.lovetoys.lovetoys"
local function Brownie(args)
	local entity = lovetoys.Entity()
	entity.name = "Wood Sprite"
	entity:add(Physics{x=args.x, y=args.y, hp=500, blocks=true, layer="creature", plane=args.plane})
	entity:add(Sprite{filename="img/sprites/brownie.png"})
	entity:add(Faction{name="ally"})
	entity:add(Ai{objective="dungeon", combatPreference="melee", idle="explore"})
	return entity
end
return Brownie
