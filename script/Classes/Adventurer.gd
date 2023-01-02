extends Sprite

# Pointers
var adventDungeon
var adventPopupTimer
var adventReactionTimer
var adventTargetMonster
var dungeonProcessor
var gameControl
var guildBed
var guildCounter
var guildGate
var guildTable
var screenGuild
var statusIcon

# Loaded values
var adventDefenseDefault
var adventDrunkBailBonus
var adventDrunkFoodBonus
var adventDrunkLevelDefault
var adventDrunkWinBonus
var adventHealthDefault
var adventMoveSpeedModDefault
var adventResponseTimeoutDefaultGuild
var adventStates
var adventStatusIcons
var adventStrengthDefault
var adventTexture

# Params
var adventConfidenceLevel
var adventPowerRating
var adventDefense
var adventDrunkLevel
var adventHealth
var adventMaxHealth
var adventMoveSpeedMod
var adventResponseTimeout
var adventState
var adventStrength
var adventTargetPosition

# Main
func _ready():
	gameControl = get_tree().current_scene.get_node("GameControl")
	screenGuild = get_tree().current_scene.get_node("Objects/Screen2/Guild")
	dungeonProcessor = get_tree().current_scene.get_node("Objects/Screen3/DungeonProcessor")
	guildGate = screenGuild.get_node("Gate")
	guildCounter = screenGuild.get_node("Counter")
	guildTable = screenGuild.get_node("Table")
	guildBed = screenGuild.get_node("Bed")
	gameControl.getConfigSetup(self, [
		"adventHealthDefault",
		"adventDefenseDefault",
		"adventDrunkBailBonus",
		"adventDrunkFoodBonus",
		"adventDrunkLevelDefault",
		"adventDrunkWinBonus",
		"adventMoveSpeedModDefault",
		"adventResponseTimeoutDefaultGuild",
		"adventStates",
		"adventStrengthDefault",
		"adventStatusIcons",
		"adventTexture",
	])
	switchState("NewAdvent")

func _process(_delta):
	match adventState:
		"NewGoingToCounter":
			if moveToTarget():
				switchState("PendingHire")
		"GoingToBar":
			if moveToTarget():
				switchState("PendingParty")
		"LeavingToDungeon":
			if moveToTarget():
				switchState("Deploying")
		"DungeonIdle":
			moveToTarget()
		"HuntingMonster":
			if moveToTarget():
				switchState("InCombat")
		"GoingToRest":
			if moveToTarget():
				switchState("Recovering")
	update()

func _input(event):
	if gameControl.testMouseInTexture(event, self, true):
		if adventState == "PendingHire":
			switchState("NewHired")

func _draw():
	drawHealth()

# Methods
func adventSetup():
	adventResponseTimeout = adventResponseTimeoutDefaultGuild
	adventMaxHealth = adventHealthDefault
	adventHealth = adventMaxHealth
	adventDefense = adventDefenseDefault
	adventStrength = adventStrengthDefault
	adventDrunkLevel = adventDrunkLevelDefault
	testConfidence(10)
	
	texture = adventTexture
	visible = false
	z_index = 1
	
	statusIcon = Sprite.new()
	add_child(statusIcon)
	statusIcon.position = position+Vector2(32, -16)

	setTimer()

func drawHealth():
	var rate = adventHealth / adventMaxHealth
	draw_rect(Rect2(-16, -16, 32*rate, 2), Color(1, 0, 0))

func displayEmote(status):
	match status:
		"Attention":
			statusIcon.texture = adventStatusIcons["Attention"]
		"Death":
			statusIcon.texture = adventStatusIcons["Death"]
		"Fighting":
			statusIcon.texture = adventStatusIcons["Fighting"]
		"Sleeping":
			statusIcon.texture = adventStatusIcons["Sleeping"]
		"Waiting":
			statusIcon.texture = adventStatusIcons["Waiting"]
		"Happy":
			statusIcon.texture = adventStatusIcons["Happy"]
		"Sad":
			statusIcon.texture = adventStatusIcons["Sad"]
	statusIcon.visible = true
	adventPopupTimer.start()

func getDungeonRandomPosition():
	adventTargetMonster = null
	adventTargetPosition = adventDungeon.getRandomValidPoint()

func getDungeonRandomMonster():
	if len(adventDungeon.dungeonMonsters) > 0:
		var mon = randi() % len(adventDungeon.dungeonMonsters)
		adventTargetMonster = adventDungeon.dungeonMonsters[mon]
		testConfidence(adventTargetMonster.monsterThreatLevel)
		if adventConfidenceLevel > 1.0:
			if !adventTargetMonster.monsterTargeted:
				switchState("HuntingMonster")
			else:
				switchState("DungeonIdle")
		else:
			switchState("Bail")
	else:
		switchState("DungeonIdle")

func getTargetPosition(obj):
	adventTargetPosition = obj.position + Vector2(8, 8)

func moveToTarget():
	return gameControl.moveToPointLinear(self, adventTargetPosition, adventMoveSpeedMod)

func moveScreens(screen):
	match screen:
		"Guild":
			adventDungeon = null
			get_parent().remove_child(self)
			screenGuild.add_child(self)
			global_position = guildGate.global_position
			adventMoveSpeedMod = adventMoveSpeedModDefault
			visible = true
		"Dungeon":
			get_parent().remove_child(self)
			adventDungeon.add_child(self)
			global_position = adventDungeon.global_position
			adventMoveSpeedMod = 1
			visible = true

func setTimer():
	adventReactionTimer = Timer.new()
	adventReactionTimer.connect("timeout", self, "timeoutProcess")
	adventReactionTimer.one_shot = true
	add_child(adventReactionTimer)
	startTimer()
	
	adventPopupTimer = Timer.new()
	adventPopupTimer.connect("timeout", self, "timeoutPopup")
	adventPopupTimer.one_shot = true
	adventReactionTimer.wait_time = 1
	add_child(adventPopupTimer)

func startTimer():
	adventReactionTimer.wait_time = adventResponseTimeout
	adventReactionTimer.start()

func switchState(state):
	match state:
		"NewAdvent":
			adventSetup()
		"PendingOutside":
			pass
		"NewArrival":
			displayEmote("Happy")
			global_position = guildGate.global_position
			visible = true
			adventMoveSpeedMod = 5
		"NewGoingToCounter":
			getTargetPosition(guildCounter)
		"PendingHire":
			displayEmote("Attention")
		"Fired":
			displayEmote("Sad")
		"NewHired":
			displayEmote("Happy")
			screenGuild.hireAdvent(self)
		"GoingToBar":
			adventMoveSpeedMod = 5
			adventResponseTimeout = 4
			getTargetPosition(guildTable)
		"PendingParty":
			displayEmote("Waiting")
			if gameControl.addInventoryItem("Food", -1):
				gameControl.addInventoryItem("Gold", 5)
				adventDrunkLevel += adventDrunkFoodBonus
			for dungeon in range(len(dungeonProcessor.dungeonList)-1, -1, -1):
				testConfidence(dungeonProcessor.dungeonList[dungeon].dungeonPowerRating)
				if adventConfidenceLevel > 1:
					adventDungeon = dungeonProcessor.dungeonList[dungeon]
		"LeavingToDungeon":
			getTargetPosition(guildGate)
			adventResponseTimeout = 1
		"Deploying":
			displayEmote("Waiting")
		"PendingDungeon":
			visible = false
		"DungeonArrival":
			moveScreens("Dungeon")
		"DungeonStop":
			pass
		"DungeonIdle":
			displayEmote("Waiting")
			getDungeonRandomPosition()
			adventResponseTimeout = rand_range(0.1, 2)
		"HuntingMonster":
			displayEmote("Fighting")
			adventTargetMonster.monsterTargeted = true
			getTargetPosition(adventTargetMonster)
		"InCombat":
			adventResponseTimeout = 1
		"CombatCelebrate":
			displayEmote("Happy")
			adventDrunkLevel += adventDrunkWinBonus
			testConfidence(adventTargetMonster.monsterThreatLevel)
		"Defeat":
			displayEmote("Death")
			adventTargetMonster.monsterTargeted = false
			adventTargetMonster = null
			adventResponseTimeout = 1
			adventDrunkLevel = adventDrunkLevelDefault
		"Recovering":
			moveScreens("Guild")
			position = guildBed.position
		"Recovered":
			displayEmote("Happy")
			adventHealth = adventMaxHealth
		"Bail":
			displayEmote("Sad")
			adventTargetMonster.monsterTargeted = false
			adventTargetMonster = null
			adventResponseTimeout = 1
			adventDrunkLevel -= adventDrunkBailBonus
		"Escaping":
			visible = false
		"ReturningFromMission":
			pass
		"ArrivedFromMission":
			moveScreens("Guild")
		"GoingToRest":
			displayEmote("Sleeping")
			getTargetPosition(guildBed)
	adventState = state

func testConfidence(against):
	updateRating()
	adventConfidenceLevel = (adventPowerRating * adventDrunkLevel) / against

func timeoutPopup():
	statusIcon.visible = false
	
func timeoutProcess():
	match adventState:
		"NewAdvent":
			switchState("PendingOutside")
		"PendingOutside":
			switchState("NewArrival")
		"NewArrival":
			switchState("NewGoingToCounter")
		"NewHired":
			switchState("GoingToBar")
		"PendingParty":
			if adventDungeon != null:
				switchState("LeavingToDungeon")
			else:
				switchState("GoingToRest")
		"Deploying":
			switchState("PendingDungeon")
		"PendingDungeon":
			switchState("DungeonArrival")
		"DungeonArrival":
			switchState("DungeonStop")
		"DungeonStop":
			routineDungeonIdle()
		"DungeonIdle":
			routineDungeonIdle()
		"InCombat":
			routineDungeonCombat()
		"CombatCelebrate":
			routineDungeonIdle()
		"Defeat":
			switchState("Recovering")
		"Recovering":
			routineRecovery()
		"Recovered":
			switchState("GoingToBar")
		"Bail":
			switchState("Escaping")
		"Escaping":
			switchState("ReturningFromMission")
		"ReturningFromMission":
			switchState("ArrivedFromMission")
		"ArrivedFromMission":
			switchState("GoingToRest")
	startTimer()

func routineDungeonIdle():
	var r = randi() % (2+1)
	match r:
		0:
			switchState("DungeonStop")
		1:
			switchState("DungeonIdle")
		2:
			getDungeonRandomMonster()

func routineDungeonCombat():
	if adventTargetMonster.monsterAlive:
		displayEmote("Fighting")
		adventTargetMonster.monsterHealth -= adventStrength/adventTargetMonster.monsterDefense
		adventHealth -= adventTargetMonster.monsterPower/adventDefense
		if adventHealth <= 0:
			switchState("Defeat")
	else:
		switchState("CombatCelebrate")

func routineRecovery():
	displayEmote("Sleeping")
	adventHealth += 5
	if adventHealth >= adventMaxHealth:
		switchState("Recovered")

func updateRating():
	adventPowerRating = (adventHealth * adventStrength * adventDefense) / 100
