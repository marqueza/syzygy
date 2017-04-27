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

        events.fireEvent(events.LevelEvent{"1-1", {} })

        local beforeCount = #systems.engine.entities
        assert.spy(lspy).was_called(1)
        assert.is_true(beforeCount >= 1)
        assert.truthy(game)
        assert.truthy(game.player)
    end)

    describe("ReplaySystem", function()

        it("series of popEvent", function ()

            --save, record, move, stop recording
            events.fireEvent(events.KeyPressEvent{key="s"})
            events.fireEvent(events.KeyPressEvent{key="q"})
            events.fireEvent(events.KeyPressEvent{key="down"})
            local startX, startY = game.player.Physics.x, game.player.Physics.y
            events.fireEvent(events.KeyPressEvent{key="down"})
            events.fireEvent(events.KeyPressEvent{key="left"})
            events.fireEvent(events.KeyPressEvent{key="q"})
            local finishX, finishY = game.player.Physics.x, game.player.Physics.y

            --store position, replay past movement, store new position
            local rspy = spy.on(events.ReplayEvent, "initialize")
            events.fireEvent(events.KeyPressEvent{key="r"})
            local newX, newY = game.player.Physics.x, game.player.Physics.y
            assert.equals(startX, newX)
            assert.equals(startY, newY)

            events.fireEvent(events.KeyPressEvent{key="r"})
            events.fireEvent(events.KeyPressEvent{key="r"})
            newX, newY = game.player.Physics.x, game.player.Physics.y
            assert.spy(rspy).was_called()
            assert.equals(finishX, newX)
            assert.equals(finishY, newY)


        end)
    end)
end)
