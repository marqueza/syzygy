local lovetoys = require "lib.lovetoys.lovetoys"
local function Cave(args)
	local entity = lovetoys.Entity()
	entity.name = "cave"
	entity:add(Physics{x=args.x, y=args.y, blocks=false, layer="backdrop", plane=args.plane})
	entity:add(Sprite{filename="img/sprites/mountain.png"})
	entity:add(Entrance{
      levelName="cave"..args.levelSeed or entity.id, 
      commandKey=">", 
      newX=args.newX, 
      newY=args.newY,
      levelDepth=args.levelDepth,
      levelSeed=args.levelSeed or entity.id
      })
	return entity
end
return Cave
