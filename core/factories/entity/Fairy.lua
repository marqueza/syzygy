local function Fairy(x, y)
	entity = Entity()
	entity:add(Physics(x, y))
	entity:add(Sprite("img/sprites/fairy.png"))
	return entity
end
return Fairy
