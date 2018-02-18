describe("level", function()
  setup(function()
    game = require("../core/game")
    game.load{headless=true, debug=false}
  end
  )
  before_each(function()
  end
  )
  after_each(function()
    removeAllEntities()
  end
  )

  it("save and load", function()

    --assemble
    fireEvent(LevelEvent{levelName="arena", levelDepth=1, options={ first=true}})
    --act
    fireEvent(SaveEvent())
    fireEvent(LoadEvent())
    --assert

  end
  )
end
)
