local function Orc(x, y)
	entity = Entity()
	entity:add(physics(x, y))
	entity:add(sprite("img/sprites/orc.png"))
	return entity
end
return Orc
