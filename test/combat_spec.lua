describe("combat", function()
  setup(function()
      game = require("../core/game")
      game.load{headless=true, debug=false}
    end
  )
  before_each(function()
      fireEvent(LevelEvent{levelName="arena", levelDepth=1, options={
          first=true}})

      fireEvent(SpawnEvent{
        name="Skeleton",
        x=3,
        y=3,
        plane="arena-1",
        hp=2}
        )
      skeleton = popEntity()
      fireEvent(SpawnEvent{
        name="Angel",
        x=4,
        y=3,
        plane="arena-1",
        hp=2}
        )
      angel = popEntity()
    end
  )
  after_each(function()
    removeAllEntities()
    end
    )
 
  it("attack", function()
      --assemble
      local angelHp =  angel.Stats.hp
      local attackSpy = spy.on(AttackEvent, "initialize")

      --act
      fireEvent(MoveEvent{moverId=skeleton.id, x=4, y=3})

      --assert
      assert.spy(attackSpy).was_called()
      assert.is_true(angel.Stats.hp < angelHp)
    end
  )
  it("death", function()
      --assemble
      local deathSpy = spy.on(DeathEvent, "initialize")
      --act
      fireEvent(MoveEvent{moverId=angel.id, x=3, y=3})
      fireEvent(MoveEvent{moverId=angel.id, x=3, y=3})
      --assert
      assert.spy(deathSpy).was_called()
    end
  )
  it("ai", function()
      --assemble
      local deathSpy = spy.on(DeathEvent, "initialize")
      local attackSpy = spy.on(AttackEvent, "initialize")
      local moveSpy = spy.on(MoveEvent, "initialize")
      local angelHp =  angel.Stats.hp

      local aiList = getEntitiesWithComponent("Ai")
      --act
      game.events.fireEvent(game.events.TurnEvent())
      fireEvent(TurnEvent())
      fireEvent(TurnEvent())
      fireEvent(TurnEvent())
      fireEvent(TurnEvent())
      --assert
      assert.spy(moveSpy).was_called()
      assert.spy(attackSpy).was_called()
      assert.spy(deathSpy).was_called()
    end
  )
end
)
