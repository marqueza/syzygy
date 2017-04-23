local function KeyPress(x, y)
	entity = Entity()
	entity:add(Physics(x, y, 1, false))
	entity:add(Sprite("img/sprites/key.png"))
	return entity
end
return KeyPress
