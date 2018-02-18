describe("spell", function()
  setup(function()
      game = require("../core/game")
      game.load{headless=true, debug=false}
    end
  )
  before_each(function()
      fireEvent(LevelEvent{levelName="arena", levelDepth=1, options={first=true}})
      skeleton = popEntity()
      fireEvent(SpawnEvent{
        name="Player",
        x=4,
        y=3,
        plane="arena-1",
        hp=2}
        )
      mage = popEntity()
    fireEvent(SpawnEvent{
        name="Book",
        spellName="return",
        x=4,
        y=3,
        plane="arena-1"}
      )
    book = popEntity()
  end )


  after_each(function()
    removeAllEntities()
    end
    )
 
  it("learn", function()
      --assemble
      local learnSpy = spy.on(SpellLearnEvent, "initialize")

      --act
      fireEvent(UseEvent{subjectId=book.id, userId=mage.id})

      --assert
      assert.spy(learnSpy).was_called()
      assert.is_true(mage.Spells.names[1] == "return")
    end
  )
  it("cast", function()
      --assemble
      local levelSpy = spy.on(LevelEvent, "initialize")
      fireEvent(UseEvent{subjectId=book.id, userId=mage.id})

      --act
      fireEvent(SpellCastEvent{spellName="return", casterId=mage.id})

      --assert
      assert.spy(levelSpy).was_called()
    end
  )
end
)
