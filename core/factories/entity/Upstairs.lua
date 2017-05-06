local lovetoys = require "lib.lovetoys.lovetoys"
local function Upstairs(args)
	local entity = lovetoys.Entity()
	entity.name = "upstairs"
	entity:add(Physics{x=args.x, y=args.y, hp=10, blocks=false})
	entity:add(Sprite{filename="img/sprites/upstairs.png", color=args.color})
	entity:add(Entrance{levelName="0-0", commandKey="<"})
	return entity
end
return Upstairs
