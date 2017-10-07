local lovetoys = require "lib.lovetoys.lovetoys"
local function Upstairs(args)
	local entity = lovetoys.Entity()
	entity.name = "upstairs"
	entity:add(Physics{x=args.x, y=args.y, hp=10, blocks=false, layer="backdrop", plane=args.plane})
	entity:add(Sprite{filename="img/sprites/upstairs.png", color=args.color})
  entity:add(Entrance{
      levelName=args.levelName, 
      commandKey="<", 
      newX=args.newX, 
      newY=args.newY,
      levelDepth=args.levelDepth,
      levelSeed=args.levelSeed
      })
	return entity
end
return Upstairs
