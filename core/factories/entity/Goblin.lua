local function Goblin(x, y)
	entity = Entity()
	entity:add(physics(x, y))
	entity:add(sprite("img/sprites/goblin.png"))
	return entity
end
return Goblin
