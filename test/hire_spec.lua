describe("clean start >", function()
    local game = require("../core/game")
    game.load{ debug = false, headless = true }
    local events = game.events
    local systems = game.systems

    describe("hire >", function()

        it("purchase", function ()
            --pretest
            local beforeCount = #systems.getEntitiesWithComponent("Reserve")
            assert.equals(0, beforeCount)
            local spawnSpy = spy.on(events, "SpawnEvent")
            local reserveSpy = spy.on(events, "ReservesEnterEvent")

            --test
            events.fireEvent(events.SpawnEvent{name="Gold", amount=100, stock=true})
            events.fireEvent(events.HirePurchaseEvent{unitName="Apprentice"})

            --posttest
            assert.spy(spawnSpy).was_called(2)
            assert.spy(reserveSpy).was_called(1)
            local reservesTable = systems.getEntitiesWithComponent("Reserve")
            local afterCount = 0
            for k, v in pairs(reservesTable) do
                afterCount = afterCount + 1
            end
            assert.equals(1, afterCount)
        end)
    end)
end)
