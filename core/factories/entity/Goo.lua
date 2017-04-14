local function Goo(x, y)
	entity = Entity()
	entity:add(Physics(x, y))
	entity:add(Sprite("img/sprites/goo.png"))
	return entity
end
return Goo
