local function Mail(x, y)
	entity = Entity()
	entity:add(Physics(x, y, 1, false))
	entity:add(Sprite("img/sprites/mail.png"))
	return entity
end
return Mail
