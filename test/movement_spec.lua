describe("arena", function()
    local game
    local events = require("../core/events/events")
    setup("arena load", function()
        --test code
        game = require("../core/game")
        game.load( {
            debug = false,
            headless = true
        })
        events.init()


        local lspy = spy.on(events.LevelEvent, "initialize")

        local options = {}
        options.empty = false
        events.fireEvent(events.LevelEvent("1-1", options))

        assert.spy(lspy).was_called(1)
        assert.truthy(game)
        assert.truthy(game.player)
    end)

    describe("movement", function()
        local oldX, oldY, newX, newY
        it("right", function ()
            oldX, oldY = game.player.Physics.x, game.player.Physics.y
            local move = spy.on(events.MoveEvent, "initialize")

            events.fireEvent(events.CommandKeyEvent("right"))
            newX, newY = game.player.Physics.x, game.player.Physics.y

            assert.spy(move).was_called(1)
            assert.are_equal(oldY,  newY)
            assert.are_equal(oldX+1,  newX)
        end)
        it("left", function ()
            oldX, oldY = game.player.Physics.x, game.player.Physics.y
            events.fireEvent(events.CommandKeyEvent("left"))
            newX, newY = game.player.Physics.x, game.player.Physics.y
            assert.are_equal(oldY,  newY)
            assert.are_equal(oldX-1,  newX)
        end)
        it("up", function ()
            oldX, oldY = game.player.Physics.x, game.player.Physics.y
            events.fireEvent(events.CommandKeyEvent("up"))
            newX, newY = game.player.Physics.x, game.player.Physics.y
            assert.are_equal(oldY-1,  newY)
            assert.are_equal(oldX,  newX)
        end)
        it("down", function ()
            oldX, oldY = game.player.Physics.x, game.player.Physics.y
            events.fireEvent(events.CommandKeyEvent("down"))
            newX, newY = game.player.Physics.x, game.player.Physics.y
            assert.are_equal(oldY+1,  newY)
            assert.are_equal(oldX,  newX)
        end)
        it("bump", function ()

            events.fireEvent(events.CommandKeyEvent("left"))
            oldX, oldY = game.player.Physics.x, game.player.Physics.y
            events.fireEvent(events.CommandKeyEvent("left"))
            newX, newY = game.player.Physics.x, game.player.Physics.y

            assert.are_equal(oldY,  newY)
            assert.are_equal(oldX,  newX)
        end)

    end)
end)
