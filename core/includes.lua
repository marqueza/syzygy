-- Importing lovetoys
lovetoys = require "lib/lovetoys/lovetoys"
lovetoys.initialize({
    globals = true,
    debug = true
})
-- serpent?
serpent = require "serpent"

require "core.config"
--Event Systems
CommandKeySystem = require("core/systems/event/CommandKeySystem")
MoveSystem = require("core/systems/event/MoveSystem")
MessageSystem = require("core/systems/event/MessageSystem")

--Graphic Systems(update and draw)
SpriteSystem = require("core/systems/graphic/SpriteSystem")
PromptSystem = require("core/systems/graphic/PromptSystem")

--Events
require("core/events/CommandKeyEvent")
require("core/events/MessageEvent")

--Factories
EntityFactory = require("core/factories/entity/EntityFactory")
Map = require("core/factories/map/Map")
