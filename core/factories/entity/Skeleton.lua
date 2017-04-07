local function Skeleton(x, y)
	entity = Entity()
	entity:add(physics(x, y))
	entity:add(sprite("img/sprites/skeleton.png"))
	return entity
end
return Skeleton
