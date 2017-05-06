local lovetoys = require "lib.lovetoys.lovetoys"
local function Ghost(args)
	local entity = lovetoys.Entity()
	entity.name = "Ghost"
	entity:add(Physics{x=args.x, y=args.y, hp=10, blocks=true})
	entity:add(Sprite{filename="img/sprites/ghost.png"})
	entity:add(Faction{name="ally"})
	return entity
end
return Ghost
