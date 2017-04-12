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

    describe("save", function()
        local oldX, oldY, newX, newY
        local events = require("../core/events/events")
        events.init()
        it("simple", function ()
            local save = spy.on(events.SaveEvent, "initialize")

            events.fireEvent(events.CommandKeyEvent("s"))

            assert.spy(save).was_called(1)
        end)

    end)
end)
