describe("Serialize >", function()
  setup(function()
      game = require("../core/game")
      game.load{headless=true, debug=false}
    end
  )

  it("Entity ToString", function()
      --assemble
      fireEvent(LevelEvent{ levelName="arena", levelDepth=1, options={first=true} })
      fireEvent(SpawnEvent{ name="Rock", x=3, y=3, plane="arena-1"}) 

      --act
      local rock = popEntity()
      local rockString = rock:toString()

      --assert
      assert.are_not.Equals("instance of class Entity", rockString)
    end
  )
end
)
