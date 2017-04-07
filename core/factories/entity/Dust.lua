local function Dust(x, y)
	entity = Entity()
	entity:add(physics(x, y))
	entity:add(sprite("img/sprites/dust.png"))
	return entity
end
return Dust
