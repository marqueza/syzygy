local function Goop(x, y)
	entity = Entity()
	entity:add(physics(x, y))
	entity:add(sprite("img/sprites/goop.png"))
	return entity
end
return Goop
