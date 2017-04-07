local function Fairy(x, y)
	entity = Entity()
	entity:add(physics(x, y))
	entity:add(sprite("img/sprites/fairy.png"))
	return entity
end
return Fairy
