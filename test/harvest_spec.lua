describe("Harvest >", function()
  setup(function()
      game = require("../core/game")
      game.load{headless=true, debug=false}
    end
  )

  it("Stone", function()
      --assemble
      fireEvent(LevelEvent{ levelName="arena", levelDepth=1, options={first=true} })
      fireEvent(SpawnEvent{ name="Rock", x=3, y=3, plane="arena-1"}) 

      --act
      local rock = popEntity()
      fireEvent(HarvestEvent{entityId=rock.id})

      --assert
      local stone = popEntity()
      assert.are.equals("stone", string.lower(stone.name))

    end
  )
end
)
