local lovetoys = require "lib.lovetoys.lovetoys"
local function Downstairs(args)
	local entity = lovetoys.Entity()
	entity.name = "Downstairs"
	entity:add(Physics{x=args.x, y=args.y, hp=10, blocks=false, layer="backdrop"})
	entity:add(Sprite{filename="img/sprites/downstairs.png", color=args.color})
	entity:add(Entrance{levelName=args.levelName, commandKey=">"})
	return entity
end
return Downstairs
