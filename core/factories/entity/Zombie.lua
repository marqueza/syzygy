local function Zombie(x, y)
	entity = Entity()
	entity:add(physics(x, y))
	entity:add(sprite("img/sprites/zombie.png"))
	return entity
end
return Zombie
