local function Skeleton(x, y)
	entity = Entity()
	entity:add(Physics(x, y))
	entity:add(Sprite("img/sprites/skeleton.png"))
	return entity
end
return Skeleton
