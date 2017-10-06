local lovetoys = require "lib.lovetoys.lovetoys"
local function Player(args)
	local entity = lovetoys.Entity()
	entity.name = "player"
	entity:add(Physics{x=args.x, y=args.y, hp=100, blocks=true, layer="creature", plane=args.plane})
	entity:add(Sprite{filename="img/sprites/pilot.png"})
  entity:add(Inventory{items={}})
	entity:add(Faction{name="ally"})
  entity:add(Party{memberIds={entity.id}})
	entity:add(Control())
	return entity
end
return Player
