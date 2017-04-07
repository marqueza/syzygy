local function Wall(x, y)
	entity = Entity()
  entity.name = "wall"
	entity:add(physics(x, y, 1, true))
	entity:add(sprite("img/sprites/wall.png"))
	return entity
end
return Wall
