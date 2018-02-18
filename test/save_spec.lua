describe("save", function()
  setup(function()
    game = require("../core/game")
  end
  )
  before_each(function()
    game.load{headless=true, debug=false, new=true}
    fireEvent(LevelEvent{levelName="arena", levelDepth=1, options={
      first=true}})
  end
  )
  after_each(function()
    removeAllEntities()
  end
  )

  it("save and load", function()
    --assemble
    fireEvent(SpawnEvent{
        name="Brownie",
        x=2,
        y=2,
        plane="arena-1"})
    brownie = popEntity()
    game.player = brownie

    --act
    fireEvent(SaveEvent())
    fireEvent(LoadEvent())

    loadedBrownie = getEntityById(brownie.id)

    --assert
    assert.are.same(brownie, loadedBrownie)
  end
  )
end
)
