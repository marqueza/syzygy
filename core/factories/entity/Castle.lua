local lovetoys = require "lib.lovetoys.lovetoys"
local function Castle(args)
	local entity = lovetoys.Entity()
	entity.name = "castle"
	entity:add(Physics{x=args.x, y=args.y, hp=10, blocks=false, layer="backdrop", plane=args.plane})
	entity:add(Sprite{filename="img/sprites/castle.png"})
	entity:add(Entrance{levelName="tower", commandKey=">"})
	return entity
end
return Castle
