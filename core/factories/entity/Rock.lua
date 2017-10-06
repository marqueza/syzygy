local lovetoys = require "lib.lovetoys.lovetoys"
local function Rock(args)
	local entity = lovetoys.Entity()
	entity.name = "rock"
	entity:add(Physics{x=args.x, y=args.y, hp=1, blocks=false, layer="backdrop", plane=args.plane})
	entity:add(Sprite{filename="img/sprites/rock.png"})
  entity:add(Harvest{loot="Stone", amount = 5})
	return entity
end
return Rock
