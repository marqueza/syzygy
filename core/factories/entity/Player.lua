local lovetoys = require "lib.lovetoys.lovetoys"
local function Player(args)
	local entity = lovetoys.Entity()
	entity.name = "player"
	entity:add(Physics{x=args.x, y=args.y, blocks=true, layer="creature", plane=args.plane})
  entity:add(Stats{hp=10, maxHp=10, str=1, dex=1, con=1})
	entity:add(Sprite{filename="img/sprites/pilot.png"})
  entity:add(Inventory{items={}})
	entity:add(Faction{name="ally"})
  local members = {}
  members[entity.id] = true
  entity:add(Party{members=members})
	entity:add(Control())
	return entity
end
return Player
