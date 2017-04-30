describe("clean start >", function()
    local game = require("../core/game")
    game.load{ debug = false, headless = true }
    local events = game.events
    local systems = game.systems

    describe("reserves >", function()

        it("enter", function ()
            --pretest
            events.fireEvent(events.SpawnEvent{})
            local unit = systems.getEntityById(1)
            assert.truthy(unit)
            local beforeCount = #systems.getEntitiesWithComponent("Reserve")
            assert.equals(0, beforeCount)
            local eventSpy = spy.on(events, "ReservesEnterEvent")

            --test
            events.fireEvent(events.ReservesEnterEvent{entityId=unit.id})

            --posttest
            assert.spy(eventSpy).was_called(1)
            assert.is_true(unit:has("Reserve"))
            local afterCount = #systems.getEntitiesWithComponent("Reserve")
            assert.equals(1, afterCount)
        end)

        it("exit", function ()
            --pretest
            local unit = systems.getEntityById(1)
            assert.truthy(unit)
            local beforeCount = #systems.getEntitiesWithComponent("Reserve")
            assert.equals(1, beforeCount)
            local eventSpy = spy.on(events, "ReservesExitEvent")

            --test
            events.fireEvent(events.ReservesExitEvent{entityId=unit.id})

            --posttest
            assert.spy(eventSpy).was_called(1)
            assert.is_false(unit:has("Reserve"))
            local afterCount = #systems.getEntitiesWithComponent("Reserve")
            assert.equals(0, afterCount)
        end)
    end)
end)
