local lovetoys = require "lib.lovetoys.lovetoys"
local function WoodDoor(args)
	entity = lovetoys.Entity()
	entity.name = "door"
	entity:add(Physics{x=args.x, y=args.y, blocks=true, layer="backdrop", plane=args.plane})
	entity:add(Sprite{filename="img/sprites/door.png", color=args.color})
  entity:add(Door{
      closeSprite="img/sprites/door.png", 
      isOpened=false,
      openSprite="img/sprites/door_open.png"})
	return entity
end
return WoodDoor
