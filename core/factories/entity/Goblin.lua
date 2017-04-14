local function Goblin(x, y)
	entity = Entity()
	entity:add(Physics(x, y))
	entity:add(Sprite("img/sprites/goblin.png"))
	return entity
end
return Goblin
