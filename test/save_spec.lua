describe("arena", function()
    local game = require("../core/game")
    game.load( {
        debug = false,
        headless = true
    })
    events = game.events
    systems = game.systems
    setup("arena load", function()

        local lspy = spy.on(events.LevelEvent, "initialize")

        events.fireEvent(events.LevelEvent("1-1", {}))

        local beforeCount = #systems.engine.entities
        assert.spy(lspy).was_called(1)
        assert.is_true(beforeCount >= 1)
        assert.truthy(game)
        assert.truthy(game.player)
    end)

    describe("saveSystem", function()

        it("save", function ()
            local beforeCount = #systems.engine.entities
            assert.is_true(beforeCount >= 1)
            local save = spy.on(events.SaveEvent, "initialize")

            events.fireEvent(events.KeyPressEvent{key="left"})
            events.fireEvent(events.KeyPressEvent{key="left"})
            events.fireEvent(events.KeyPressEvent{key="left"})
            events.fireEvent(events.KeyPressEvent{key="s"})

            assert.spy(save).was_called(1)
        end)

        it("load", function ()
            local levent = spy.on(events.LoadEvent, "initialize")
            local beforeCount = #systems.engine.entities
            assert.is_true(beforeCount >= 1)
            local beforeTurn = systems.turnSystem.turn
            local beforeLog = systems.logSystem.messageLog
            local beforeEventLog = systems.logSystem.eventLog
            assert.truthy(beforeLog)
            assert.truthy(beforeEventLog)
            assert.truthy(beforeTurn)

            events.fireEvent(events.LoadEvent{})

            local afterCount = #systems.engine.entities
            local afterTurn = systems.turnSystem.turn
            local afterLog = systems.logSystem.messageLog
            local afterEventLog = systems.logSystem.eventLog

            assert.spy(levent).was_called(1)
            assert.are_same(beforeCount, afterCount)
            assert.are_same(beforeTurn, afterTurn)
            assert.are_same(beforeLog, afterLog)

            assert.are_not_equal(#afterLog, 0)
            assert.are_not_equal(#afterEventLog, 0)
        end)
    end)
end)
