local function Mail(x, y)
	entity = Entity()
	entity:add(physics(x, y, 1, false))
	entity:add(sprite("img/sprites/mail.png"))
	return entity
end
return Mail
