describe("arena", function()
    local game
    setup("arena load", function()
        --test code
        game = require("../core/game")
        game.load( {
            debug = false,
            headless = true
        })
        assert.truthy(game)
        assert.truthy(game.player)
    end)

    describe("save & load", function()
        local events = require("../core/events/events")
        local systems = require("../core/systems/systems")

        events.init()
        systems.init()
        it("save", function ()
            local save = spy.on(events.SaveEvent, "initialize")

            events.fireEvent(events.CommandKeyEvent("s"))

            assert.spy(save).was_called(1)
        end)

        it("load", function ()
            local levent = spy.on(events.LoadEvent, "initialize")
            local beforeCount = #systems.engine.entities
            local beforeTurn = systems.turnSystem.turn
            local beforeLog = systems.messageSystem.log

            events.fireEvent(events.CommandKeyEvent("l"))

            local afterCount = #systems.engine.entities
            local afterTurn = systems.turnSystem.turn
            local afterLog = systems.messageSystem.log

            assert.spy(levent).was_called(1)
            assert.are_equal(beforeCount, afterCount)
            assert.are_equal(beforeTurn, afterTurn)
            assert.are_equal(beforeLog, afterLog)
        end)
    end)
end)
