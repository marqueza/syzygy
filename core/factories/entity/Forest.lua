local lovetoys = require "lib.lovetoys.lovetoys"
local function Forest(args)
	local entity = lovetoys.Entity()
	entity.name = "Forest"
	entity:add(Physics{x=args.x, y=args.y, hp=10, blocks=false, layer="backdrop", plane=args.plane})
	entity:add(Sprite{filename="img/sprites/forest.png"})
	entity:add(Entrance{
      levelName="forest"..args.levelSeed,
      commandKey=">", 
      newX=args.newX, 
      newY=args.newY,
      levelDepth=args.levelDepth,
      levelSeed=args.levelSeed
      })
	return entity
end
return Forest
