local function Floor(x, y)
	entity = Entity()
  entity.name = "floor"
	entity:add(physics(x, y, 1, false))
	entity:add(sprite("img/sprites/floor.png"))
	return entity
end
return Floor
