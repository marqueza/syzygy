local function Goo(x, y)
	entity = Entity()
	entity:add(physics(x, y))
	entity:add(sprite("img/sprites/goo.png"))
	return entity
end
return Goo
