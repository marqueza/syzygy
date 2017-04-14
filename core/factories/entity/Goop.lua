local function Goop(x, y)
	entity = Entity()
	entity:add(Physics(x, y))
	entity:add(Sprite("img/sprites/goop.png"))
	return entity
end
return Goop
