local function Kobold(x, y)
	entity = Entity()
	entity.name = "Kobold"
	entity:add(physics(x, y, 10, true))
	entity:add(faction("hostile"))
	entity:add(sprite("img/sprites/kobold.png"))
	return entity
end
return Kobold
