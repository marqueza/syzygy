local function Angel(x, y)
	entity = Entity()
	entity.name = "angel"
	entity:add(physics(x,y, 10, true))
	entity:add(faction("hostile"))
	entity:add(sprite("img/sprites/angel.png"))
	return entity
end
return Angel
