describe("clean start >", function()
    local game = require("../core/game")
    game.load{ debug = false, headless = true }
    local events = game.events
    local systems = game.systems

    describe("mission >", function()

        it("enter", function ()
            --pretest
            events.fireEvent(events.SpawnEvent{})
            local unit = systems.getEntityById(1)
            assert.truthy(unit)
            local beforeCount = #systems.getEntitiesWithComponent("Mission")
            assert.equals(0, beforeCount)
            local eventSpy = spy.on(events, "MissionEmbarkEvent")

            --test
            events.fireEvent(events.ReservesEnterEvent{entityId=unit.id})
            events.fireEvent(events.MissionEmbarkEvent{unitId=1, turnsRemaining=2})

            --posttest
            assert.spy(eventSpy).was_called(1)
            assert.is_true(unit:has("Mission"))
            local afterCount = #systems.getEntitiesWithComponent("Mission")
            assert.equals(1, afterCount)
        end)

        it("exit", function ()
            --pretest
            local unit = systems.getEntityById(1)
            assert.truthy(unit)
            local beforeCount = #systems.getEntitiesWithComponent("Mission")
            assert.equals(1, beforeCount)
            local eventSpy = spy.on(events, "MissionExitEvent")

            --test
            events.fireEvent(events.TurnEvent())
            events.fireEvent(events.TurnEvent())
            events.fireEvent(events.TurnEvent())
            --events.fireEvent(events.MissionExitEvent{entityId=unit.id})

            --posttest
            assert.spy(eventSpy).was_called(1)
            assert.is_false(unit:has("Mission"))
            local afterCount = #systems.getEntitiesWithComponent("Mission")
            assert.equals(0, afterCount)
        end)
    end)
end)
