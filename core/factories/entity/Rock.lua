local lovetoys = require "lib.lovetoys.lovetoys"
local function Rock(args)
	local entity = lovetoys.Entity()
	entity.name = "rock"
	entity:add(Physics{x=args.x, y=args.y, hp=1, blocks=false, layer="backdrop"})
	entity:add(Sprite{filename="img/sprites/rock.png"})
	return entity
end
return Rock
