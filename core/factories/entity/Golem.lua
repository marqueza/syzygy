local function Golem(x, y)
	entity = Entity()
	entity:add(physics(x, y))
	entity:add(sprite("img/sprites/golem.png"))
	return entity
end
return Golem
