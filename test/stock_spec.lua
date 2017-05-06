describe("clean start >", function()
    local game = require("../core/game")
    game.load{ debug = false, headless = true }
    local events = game.events
    local systems = game.systems

    describe("stock >", function()

        it("enter", function ()
            --pretest
            events.fireEvent(events.SpawnEvent{ name="Gold", x=1, y=1, amount=100 })
            local unit = systems.getEntityById(1)
            assert.truthy(unit)
            local beforeCount = #systems.getEntitiesWithComponent("Stock")
            assert.equals(0, beforeCount)
            local eventSpy = spy.on(events, "StockEnterEvent")

            --test
            events.fireEvent(events.StockEnterEvent{entityId=unit.id})

            --posttest
            assert.spy(eventSpy).was_called(1)
            assert.is_true(unit:has("Stock"))
            local afterCount = #systems.getEntitiesWithComponent("Stock")
            assert.equals(1, afterCount)
        end)

        it("exit", function ()
            --pretest
            local unit = systems.getEntityById(1)
            assert.truthy(unit)
            local beforeCount = #systems.getEntitiesWithComponent("Stock")
            assert.equals(1, beforeCount)
            local eventSpy = spy.on(events, "StockExitEvent")

            --test
            events.fireEvent(events.StockExitEvent{entityId=unit.id})

            --posttest
            assert.spy(eventSpy).was_called(1)
            assert.is_false(unit:has("Stock"))
            local afterCount = #systems.getEntitiesWithComponent("Stock")
            assert.equals(0, afterCount)
        end)
    end)
end)
