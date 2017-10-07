local lovetoys = require "lib.lovetoys.lovetoys"
local function Castle(args)
	local entity = lovetoys.Entity()
	entity.name = "castle"
	entity:add(Physics{x=args.x, y=args.y, hp=10, blocks=false, layer="backdrop", plane=args.plane})
	entity:add(Sprite{filename="img/sprites/castle.png"})
	entity:add(Entrance{
      levelName="tower"..args.levelSeed or entity.id,  
      commandKey=">", 
      newX=args.newX, 
      newY=args.newY,
      levelDepth=args.levelDepth,
      levelSeed=args.levelSeed or entity.id
      })
	return entity
end
return Castle
