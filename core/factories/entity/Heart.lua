local function Sword(x, y)
	entity = Entity()
	entity:add(physics(x, y))
	entity:add(sprite("img/sprites/sword.png"))
	return entity
end
return Sword
