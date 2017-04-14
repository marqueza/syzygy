local function Angel(x, y)
	entity = Entity()
	entity.name = "angel"
	entity:add(Physics(x,y, 10, true))
	entity:add(Faction("hostile"))
	entity:add(Sprite("img/sprites/angel.png"))
	return entity
end
return Angel
