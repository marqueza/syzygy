local lovetoys = require "lib.lovetoys.lovetoys"
local function Tree(args)
	local entity = lovetoys.Entity()
	entity.name = "Tree"
	entity:add(Physics{x=args.x, y=args.y, hp=1, blocks=false, layer="backdrop", plane=args.plane})
	entity:add(Sprite{filename="img/sprites/tree.png"})
  entity:add(Harvest{loot="Wood"})
	return entity
end
return Tree
