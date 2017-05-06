describe("clean start >", function()
    local game = require("../core/game")
    game.load( {
        debug = false,
        headless = true
    })
    events = game.events
    systems = game.systems

    describe("spawn >", function()

        it("ghost", function ()
            --pretest
            assert.is_truthy(game.systems.spawnSystem)
            assert.is_truthy(game.systems.spawnSystem.onNotify)
            local beforeCount = #systems.engine.entities
            assert.equals(0, beforeCount)
            local spawn = spy.on(events.SpawnEvent, "initialize")

            --test
            events.fireEvent(events.SpawnEvent{name="Ghost", x=1,y=1})

            --posttest
            assert.spy(spawn).was_called(1)
            local afterCount = #systems.engine.entities
            assert.equals(1, afterCount)
            local unit = systems.getEntityById(1)
            assert.truthy(unit)
        end)

    end)
end)
