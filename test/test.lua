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

    describe("movement", function()
        local oldX, oldY, newX, newY
        local events = require("../core/events/events")
        events.register()
        it("right", function ()
            oldX, oldY = game.player.physics.x, game.player.physics.y
            local s = spy.on(MoveEvent, "initialize")

            events.fireEvent(CommandKeyEvent("right"))
            newX, newY = game.player.physics.x, game.player.physics.y

            assert.spy(s).was_called()
            assert.are_equal(oldY,  newY)
            assert.are_equal(oldX+1,  newX)
        end)
        it("left", function ()
            oldX, oldY = game.player.physics.x, game.player.physics.y
            events.fireEvent(CommandKeyEvent("left"))
            newX, newY = game.player.physics.x, game.player.physics.y
            assert.are_equal(oldY,  newY)
            assert.are_equal(oldX-1,  newX)
        end)
        it("up", function ()
            oldX, oldY = game.player.physics.x, game.player.physics.y
            events.fireEvent(CommandKeyEvent("up"))
            newX, newY = game.player.physics.x, game.player.physics.y
            assert.are_equal(oldY-1,  newY)
            assert.are_equal(oldX,  newX)
        end)
        it("down", function ()
            oldX, oldY = game.player.physics.x, game.player.physics.y
            events.fireEvent(CommandKeyEvent("down"))
            newX, newY = game.player.physics.x, game.player.physics.y
            assert.are_equal(oldY+1,  newY)
            assert.are_equal(oldX,  newX)
        end)
        it("bump", function ()
            events.fireEvent(CommandKeyEvent("left"))
            oldX, oldY = game.player.physics.x, game.player.physics.y
            events.fireEvent(CommandKeyEvent("left"))
            newX, newY = game.player.physics.x, game.player.physics.y
            assert.are_equal(oldY,  newY)
            assert.are_equal(oldX,  newX)
        end)

    end)
    describe("", function()
        it()
    end)
end)
