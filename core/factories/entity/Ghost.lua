local function Ghost(x, y)
	entity = Entity()
	entity:add(physics(x, y))
	entity:add(sprite("img/sprites/ghost.png"))
	return entity
end
return Ghost
