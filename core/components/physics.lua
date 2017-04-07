local physics  = Component.create("physics")

function physics:initialize(x, y, hp, blocks)
    self.x = x
    self.y = y
    self.hp = hp or 10
    self.blocks = blocks
end
