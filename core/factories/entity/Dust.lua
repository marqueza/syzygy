local function Dust(x, y)
	entity = Entity()
	entity:add(Physics(x, y))
	entity:add(Sprite("img/sprites/dust.png"))
	return entity
end
return Dust
