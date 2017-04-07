local function Kobold(x, y)
	entity = Entity()
	entity:add(physics(x, y))
	entity:add(sprite("img/sprites/kobold.png"))
	return entity
end
return Kobold
