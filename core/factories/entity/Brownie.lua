local lovetoys = require "lib.lovetoys.lovetoys"
local function Brownie(args)
	local entity = lovetoys.Entity()
	entity.name = "Wood Sprite"
	entity:add(Physics{x=args.x, y=args.y, blocks=true, layer="creature", plane=args.plane})
  entity:add(Stats{hp=5, str=1, dex=1, con=1})
	entity:add(Sprite{filename="img/sprites/brownie.png"})
	entity:add(Faction{name="hostile"})
	--entity:add(Ai{objective="dungeon", combatPreference="melee", idle="explore"})
  entity:add(Ai{combatPreference="melee", idle="still", objective="kill"})
  entity:add(Recruit{desire="Wood", amount=20})
	return entity
end
return Brownie
