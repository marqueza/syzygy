local serpent = require "lib.serpent"
local lovetoys = require "lib.lovetoys.lovetoys"
local systems = require "core.systems.systems"
local filer = require "data.filer"
local events = {}

filer.requireDirectoryItems(events, "events", "core/events/")

function events.init()

    events.eventManager = lovetoys.EventManager()
    events.eventManager:addListener("KeyPressEvent", systems.keyPressSystem, systems.keyPressSystem.onNotify)
    events.eventManager:addListener("MoveEvent", systems.moveSystem, systems.moveSystem.onNotify)
    events.eventManager:addListener("LogEvent", systems.logSystem, systems.logSystem.onNotify)
    events.eventManager:addListener("TurnEvent", systems.turnSystem, systems.turnSystem.onNotify)
    events.eventManager:addListener("LevelEvent", systems.levelSystem, systems.levelSystem.onNotify)
    events.eventManager:addListener("StateEvent", systems.stateSystem, systems.stateSystem.onNotify)
    events.eventManager:addListener("SpawnEvent", systems.spawnSystem, systems.spawnSystem.onNotify)


    --replay system
    events.eventManager:addListener("MoveEvent", systems.replaySystem, systems.replaySystem.pushEvent)
    events.eventManager:addListener("ReplayEvent", systems.replaySystem, systems.replaySystem.popEvent)
    events.eventManager:addListener("ToggleRecording", systems.replaySystem, systems.replaySystem.toggleRecording)

    --save system
    events.eventManager:addListener("SaveEvent", systems.saveSystem, systems.saveSystem.onSaveNotify)
    events.eventManager:addListener("LoadEvent", systems.saveSystem, systems.saveSystem.onLoadNotify)


    --target system
    events.eventManager:addListener("FocusEvent", systems.targetSystem, systems.targetSystem.onFocusNotify)
    events.eventManager:addListener("LoadEvent", systems.targetSystem, systems.targetSystem.refreshFocus)
    events.eventManager:addListener("LevelEvent", systems.targetSystem, systems.targetSystem.refreshFocus)


    --reserves systems
    events.eventManager:addListener("ReservesEnterEvent", systems.reservesSystem, systems.reservesSystem.onEnterNotify)
    events.eventManager:addListener("ReservesExitEvent", systems.reservesSystem, systems.reservesSystem.onExitNotify)

    --mission system
    events.eventManager:addListener("TurnEvent", systems.missionSystem, systems.missionSystem.onTurnNotify)
    events.eventManager:addListener("MissionEmbarkEvent", systems.missionSystem, systems.missionSystem.onEmbarkNotify)
    events.eventManager:addListener("MissionExitEvent", systems.missionSystem, systems.missionSystem.onExitNotify)
    events.eventManager:addListener("MissionUnitEvent", systems.missionSystem, systems.missionSystem.onUnitNotify)
    events.eventManager:addListener("MissionLocationEvent", systems.missionSystem, systems.missionSystem.onLocationNotify)
    events.eventManager:addListener("MissionTaskEvent", systems.missionSystem, systems.missionSystem.onTaskNotify)

    --stock system
    events.eventManager:addListener("StockEnterEvent", systems.stockSystem, systems.stockSystem.onEnterNotify)
    events.eventManager:addListener("StockExitEvent", systems.stockSystem, systems.stockSystem.onExitNotify)
    events.eventManager:addListener("StockDisplayEvent", systems.stockSystem, systems.stockSystem.onDisplayNotify)

    --hire system
    events.eventManager:addListener("HireBrowseEvent", systems.hireSystem, systems.hireSystem.onBrowseNotify)
    events.eventManager:addListener("HirePurchaseEvent", systems.hireSystem, systems.hireSystem.onPurchaseNotify)

    --combat system
    events.eventManager:addListener("AttackEvent", systems.combatSystem, systems.combatSystem.onAttackNotify)

    --ai sytem
    events.eventManager:addListener("TurnEvent", systems.aiSystem, systems.aiSystem.onTurnNotify)

    --inventory system
    events.eventManager:addListener("InventoryEnterEvent", systems.inventorySystem, systems.inventorySystem.onEnterNotify)
    events.eventManager:addListener("InventoryExitEvent", systems.inventorySystem, systems.inventorySystem.onExitNotify)
    events.eventManager:addListener("InventoryDisplayEvent", systems.inventorySystem, systems.inventorySystem.onDisplayNotify)

    --death system
    events.eventManager:addListener("DeathEvent", systems.deathSystem, systems.deathSystem.onNotify)

    --fov system
    events.eventManager:addListener("TurnEvent", systems.fovSystem, systems.fovSystem.onNotify)
    events.eventManager:addListener("LevelEvent", systems.fovSystem, systems.fovSystem.onNotify)

    --harvest system
    events.eventManager:addListener("HarvestEvent", systems.harvestSystem, systems.harvestSystem.onNotify)

    --interact system
    events.eventManager:addListener("InteractEnterEvent", systems.interactSystem, systems.interactSystem.onEnterNotify)
    events.eventManager:addListener("InteractSelectEvent", systems.interactSystem, systems.interactSystem.onSelectNotify)

    --interact system
    events.eventManager:addListener("PartyEnterEvent", systems.partySystem, systems.partySystem.onEnterNotify)
    events.eventManager:addListener("PartyExitEvent", systems.partySystem, systems.partySystem.onExitNotify)

    --spell system
    events.eventManager:addListener("SpellLearnEvent", systems.spellSystem, systems.spellSystem.onSpellLearn)
    events.eventManager:addListener("SpellCastEvent", systems.spellSystem, systems.spellSystem.onSpellCast)
    events.eventManager:addListener("SpellDisplayEvent", systems.spellSystem, systems.spellSystem.onSpellDisplay)

    --use system
    events.eventManager:addListener("UseEvent", systems.useSystem, systems.useSystem.onUse)

    if not game.options.headless then
        events.eventManager:addListener("TurnEvent", systems.promptSystem, systems.promptSystem.flushPrompt)
        events.eventManager:addListener("LevelEvent", systems.promptSystem, systems.promptSystem.flushPrompt)
        events.eventManager:addListener("FocusEvent", systems.infoBoxSystem, systems.infoBoxSystem.onFocusNotify)
        events.eventManager:addListener("LoadEvent", systems.infoBoxSystem, systems.infoBoxSystem.onFocusNotify)
        events.eventManager:addListener("TurnEvent", systems.infoBoxSystem, systems.infoBoxSystem.refreshInfoBox)
        events.eventManager:addListener("MenuCommandEvent", systems.menuSystem, systems.menuSystem.onCommmandNotify)
        events.eventManager:addListener("MenuDisplayEvent", systems.menuSystem, systems.menuSystem.onDisplayNotify)
        events.eventManager:addListener("LevelEvent", systems.cameraSystem, systems.cameraSystem.recenterCamera)
        events.eventManager:addListener("TurnEvent", systems.cameraSystem, systems.cameraSystem.recenterCamera)
        events.eventManager:addListener("FocusEvent", systems.cameraSystem, systems.cameraSystem.recenterCamera)
        events.eventManager:addListener("LoadEvent", systems.cameraSystem, systems.cameraSystem.recenterCamera)
        events.eventManager:addListener("TitleEnterEvent", systems.titleSystem, systems.titleSystem.onEnterNotify)
        events.eventManager:addListener("TitleSelectEvent", systems.titleSystem, systems.titleSystem.onSelectNotify)
        events.eventManager:addListener("TurnEvent", systems.sideBarSystem, systems.sideBarSystem.refreshSideBar)

    end
end

function events.fireEvent(event)
    local start
    if not game.options.headless then
      start = love.timer.getTime()
    end
      events.eventManager:fireEvent(event)
    if not game.options.headless then
      local result = love.timer.getTime() - start
      result = math.floor(result*1000)
    end

    if event.toString then
        if game.options.debug then
            --captures all events and places a debug message
            events.eventManager:fireEvent(events.LogEvent{
                text="["..result.."] " .. event:toString(),
                })
        end
        events.eventManager:fireEvent(events.LogEvent{
            text=event:toString(),
            type="event"})
    end
end
return events
