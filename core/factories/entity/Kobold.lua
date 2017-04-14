local function Kobold(x, y)
	entity = Entity()
	entity.name = "Kobold"
	entity:add(Physics(x, y, 10, true))
	entity:add(Faction("hostile"))
	entity:add(Sprite("img/sprites/kobold.png"))
	return entity
end
return Kobold
