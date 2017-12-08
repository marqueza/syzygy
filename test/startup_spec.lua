local game
describe("Startup >", function()
  setup(function()
      game = require("../core/game")
      events = game.events
      systems = game.systems
      game.load{headless=true, debug=false}
    end
  )

  it("Fire Event", function()
    local sOnNotify = spy.on(game.systems.turnSystem, "onNotify")
    local sEvent = spy.on(game.events.LevelEvent, "initialize")
    game.events.fireEvent(game.events.TurnEvent())
    local turn = systems.turnSystem.turn
    assert.is.Equals(2, turn)
  end
  )
  it("Launch", function()
      game.events.fireEvent(game.events.LevelEvent{levelName="dungeon", levelDepth=1, options={
          first=true,
          spawnPlayer=true}})
      local entities = game.systems.getEntities()
      assert.is_truthy(next(game.systems.getEntities()))
    end
  )
end
)
