local lovetoys = require "lib.lovetoys.lovetoys"
local function Player(args)
	entity = lovetoys.Entity()
	entity.name = "player"
	entity:add(Physics{x=args.x, y=args.y, hp=100, blocks=true, layer="creature", plane=args.plane})
	entity:add(Sprite{filename="img/sprites/human.png"})
	entity:add(Faction{name="ally"})
	entity:add(Control())
	return entity
end
return Player
