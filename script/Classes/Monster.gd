extends Sprite

# Pointers
var gameControl
var monsterTimer

# Loaded values
var monsterMoveSpeedMod
var monsterMaxHealth
var monsterHealth
var monsterName
var monsterMoveTimer
var monsterTexture
var monsterPower
var monsterDefense
var monsterLoot

# Params
var monsterDungeon = null
var monsterAlive = true
var monsterTargeted = false
var monsterTargetPosition
var monsterThreatLevel

# Main
func _ready():
	gameControl = get_tree().current_scene.get_node("GameControl")
	gameControl.getConfigSetup(self, [
		"monsterMoveSpeedMod",
		"monsterMoveTimer",
		"monsterLoot"
	])
	monsterHealth = monsterMaxHealth
	monsterThreatLevel = (monsterHealth * monsterPower * monsterDefense) / 100
	self.texture = monsterTexture
	setTimer()
	getRandomDungeonPosition()

func _process(_delta):
	if monsterHealth <= 0:
		monsterDie()
	if !monsterTargeted:
		moveToTarget()
	update()

func _draw():
	var rate = monsterHealth / monsterMaxHealth
	draw_rect(Rect2(-16, -16, 32*rate, 2), Color(1, 0, 0))
	gameControl.drawTextCentered(self, Vector2(0, -4), monsterName)

# Methods
func getRandomDungeonPosition():
	monsterTargetPosition = monsterDungeon.getRandomValidPoint()

func giveLoot():
	for loot in monsterLoot:
		gameControl.addInventoryItem(loot, monsterLoot[loot])

func monsterDie():
	monsterTargeted = false
	monsterAlive = false
	giveLoot()
	monsterDungeon.killMonster(self)

func moveToTarget():
	var angle = atan2(position.y - monsterTargetPosition.y, position.x - monsterTargetPosition.x)
	position -= Vector2(cos(angle)*monsterMoveSpeedMod, sin(angle)*monsterMoveSpeedMod)
	if position.distance_to(monsterTargetPosition) < 2:
		position = monsterTargetPosition

func setTimer():
	monsterTimer = Timer.new()
	monsterTimer.connect("timeout", self, "timeoutProcess")
	monsterTimer.wait_time = monsterMoveTimer
	add_child(monsterTimer)
	monsterTimer.start()

func timeoutProcess():
	getRandomDungeonPosition()
	monsterMoveTimer = rand_range(5, 10)
	monsterTimer.wait_time = monsterMoveTimer
	monsterTimer.start()
