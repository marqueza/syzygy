local lovetoys = require "lib.lovetoys.lovetoys"
local function Downstairs(args)
	local entity = lovetoys.Entity()
	entity.name = "Downstairs"
	entity:add(Physics{x=args.x, y=args.y, blocks=false, layer="backdrop", plane=args.plane})
	entity:add(Sprite{filename="img/sprites/downstairs.png", color=args.color})
	entity:add(Entrance{
      levelName=args.levelName or entity.id, 
      commandKey=">", 
      newX=args.newX, 
      newY=args.newY,
      levelDepth=args.levelDepth,
      levelSeed=args.levelSeed or entity.id
      })
	return entity
end
return Downstairs
