local game
describe("Startup >", function()
  setup(function()
      game = require("../core/game")
      events = game.events
      systems = game.systems
      game.load{headless=true, debug=false}
    end
  )

  it("Turn", function()
    local sOnNotify = spy.on(game.systems.turnSystem, "onNotify")
    local turnSpy = spy.on(game.events.TurnEvent, "initialize")
    game.events.fireEvent(game.events.TurnEvent())
    local turn = systems.turnSystem.turn
    assert.is.Equals(2, turn)
    assert.spy(turnSpy).was_called()
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
