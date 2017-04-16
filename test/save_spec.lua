describe("arena", function()
    events = require("../core/events/events")
    --test code
    game = require("../core/game")
    game.load( {
        debug = false,
        headless = true
    })
    events.init()
    systems.init()
    setup("arena load", function()

        local lspy = spy.on(events.LevelEvent, "initialize")

        events.fireEvent(events.LevelEvent("1-1", {}))

        local beforeCount = #systems.engine.entities
        assert.spy(lspy).was_called(1)
        assert.is_true(beforeCount >= 1)
        assert.truthy(game)
        assert.truthy(game.player)
    end)

    describe("save & load", function()

        it("save", function ()
            local beforeCount = #systems.engine.entities
            assert.is_true(beforeCount >= 1)
            local save = spy.on(events.SaveEvent, "initialize")

            events.fireEvent(events.CommandKeyEvent("s"))

            assert.spy(save).was_called(1)
        end)

        it("load", function ()
            local levent = spy.on(events.LoadEvent, "initialize")
            local beforeCount = #systems.engine.entities
            assert.is_true(beforeCount >= 1)
            local beforeTurn = systems.turnSystem.turn
            local beforeLog = systems.logSystem.messageLog
            local beforeEventLog = systems.logSystem.eventLog

            events.fireEvent(events.CommandKeyEvent("l"))

            local afterCount = #systems.engine.entities
            local afterTurn = systems.turnSystem.turn
            local afterLog = systems.logSystem.messageLog
            local afterEventLog = systems.logSystem.eventLog

            assert.spy(levent).was_called(1)
            assert.are_same(beforeCount, afterCount)
            assert.are_same(beforeTurn, afterTurn)
            assert.are_same(beforeLog, afterLog)
            assert.are_same(beforeEventLog, afterEventLog)
        end)
    end)
end)
