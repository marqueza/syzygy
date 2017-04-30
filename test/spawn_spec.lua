describe("clean start", function()
    local game = require("../core/game")
    game.load( {
        debug = false,
        headless = true
    })
    events = game.events
    systems = game.systems

    describe("spawn", function()

        it("ghost", function ()
            --pretest
            assert.is_truthy(game.systems.spawnSystem)
            assert.is_truthy(game.systems.spawnSystem.onNotify)
            local beforeCount = #systems.engine.entities
            assert.equals(beforeCount, 0)
            local spawn = spy.on(events.SpawnEvent, "initialize")

            --test
            events.fireEvent(events.SpawnEvent{})

            --posttest
            assert.spy(spawn).was_called(1)
            local afterCount = #systems.engine.entities
            assert.equals(afterCount, 1)
        end)

    end)
end)
