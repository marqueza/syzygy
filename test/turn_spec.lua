local game
describe("turn", function()
  setup(function()
      game = require("../core/game")
      events = game.events
      systems = game.systems
      game.load{headless=true, debug=false}
    end
  )
  it("count", function()
    local sOnNotify = spy.on(game.systems.turnSystem, "onNotify")
    local turnSpy = spy.on(game.events.TurnEvent, "initialize")
    game.events.fireEvent(game.events.TurnEvent())
    local turn = systems.turnSystem.turn
    assert.is.Equals(2, turn)
    assert.spy(turnSpy).was_called()
  end
  )
end
)
