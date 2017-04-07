local physics  = Component.create("physics")

function physics:initialize(args)
    self.x = args.x
    self.y = args.y
    self.blocks = args.blocks
    self.hp = args.hp or 10
end
