local lovetoys = require "lib.lovetoys.lovetoys"
local function Player(args)
	entity = lovetoys.Entity()
	entity.name = "player"
	entity:add(Physics{x=args.y, y=args.y, hp=100, blocks=true, layer="character"})
	entity:add(Sprite{filename="img/sprites/kobold.png"})
	entity:add(Faction{name="ally"})
	entity:add(Control())
	return entity
end
return Player
