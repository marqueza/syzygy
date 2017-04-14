local function Ghost(x, y)
	entity = Entity()
	entity:add(Physics(x, y))
	entity:add(Sprite("img/sprites/ghost.png"))
	return entity
end
return Ghost
