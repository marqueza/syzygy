local lovetoys = require "lib.lovetoys.lovetoys"
local function CaveWall(args)
	entity = lovetoys.Entity()
	entity.name = "wall"
	entity:add(Physics{x=args.x, y=args.y, blocks=true, layer="backdrop", plane=args.plane})
  if args.variant=="A" then
    entity:add(Sprite{filename="img/sprites/cave_wall_A.png", color=args.color})
  else
    entity:add(Sprite{filename="img/sprites/cave_wall_B.png", color=args.color})
  end
	return entity
end
return CaveWall
