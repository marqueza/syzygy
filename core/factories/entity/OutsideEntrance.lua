local lovetoys = require "lib.lovetoys.lovetoys"
local function OutsideEntrace(args)
	local entity = lovetoys.Entity()
	entity.name = "upstairs"
	entity:add(Physics{x=args.x, y=args.y, hp=10, blocks=false})
	entity:add(Sprite{filename="img/sprites/outside_entrance.png", color=args.color})
	entity:add(Entrance{levelName=args.levelName, commandKey="<"})
	return entity
end
return OutsideEntrace
