local function Zombie(x, y)
	entity = Entity()
	entity:add(Physics(x, y))
	entity:add(Sprite("img/sprites/zombie.png"))
	return entity
end
return Zombie
