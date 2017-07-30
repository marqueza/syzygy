local lovetoys = require "lib.lovetoys.lovetoys"
local function CaveWall(args)
	entity = lovetoys.Entity()
	entity.name = "wall"
	entity:add(Physics{x=args.x, y=args.y, hp=1, blocks=true, layer="backdrop"})
  if args.variant=="A" then
    entity:add(Sprite{filename="img/sprites/cave_wall_A.png", color=args.color})
  else
    entity:add(Sprite{filename="img/sprites/cave_wall_B.png", color=args.color})
  end
	return entity
end
return CaveWall
