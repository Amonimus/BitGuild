extends Sprite

# Pointers
var dungeonTimer
var gameControl

# Loaded values
var dungeonMonsterMax
var dungeonMonsterScript
var dungeonName
var dungeonSpawnTimeout
var dungeonWallOffset

var monsterDefense
var monsterMaxHealth
var monsterName
var monsterPower

# Params
var dungeonDims
var dungeonMonster
var dungeonMonsters = []
var dungeonPowerRating

# Main
func _ready():
	gameControl = get_tree().current_scene.get_node("GameControl")
	gameControl.getConfigSetup(self, [
		"dungeonMonsterMax",
		"dungeonMonsterScript",
		"dungeonSpawnTimeout",
		"dungeonWallOffset"
	])
	getMonsterPower()
	getSize()
	setTimer()

# Methods
func getMonsterPower():
	dungeonPowerRating = (dungeonMonster.maxHealth * dungeonMonster.strength * dungeonMonster.defense) / 100

func getRandomValidPoint():
	var xRange = dungeonDims.x-dungeonWallOffset
	var yRange = dungeonDims.y-dungeonWallOffset
	return Vector2(rand_range(-xRange, xRange), rand_range(-yRange, yRange))

func getSize():
	dungeonDims = Vector2(texture.get_width()/2, texture.get_height()/2)

func killMonster(monster):
	dungeonMonsters.erase(monster)
	remove_child(monster)

func setTimer():
	dungeonTimer = Timer.new()
	dungeonTimer.connect("timeout", self, "timeoutProcess")
	dungeonTimer.wait_time = dungeonSpawnTimeout
	add_child(dungeonTimer)
	dungeonTimer.start()

func spawnMonster():
	if len(dungeonMonsters) < dungeonMonsterMax:
		var newMonster = Sprite.new()
		newMonster.set_script(dungeonMonsterScript)
		newMonster.monsterDungeon = self
		newMonster.monsterName = dungeonMonster.name
		newMonster.monsterMaxHealth = dungeonMonster.maxHealth
		newMonster.monsterTexture = dungeonMonster.texture
		newMonster.monsterPower = dungeonMonster.strength
		newMonster.monsterDefense = dungeonMonster.defense
		add_child(newMonster)
		dungeonMonsters.append(newMonster)
		newMonster.position = getRandomValidPoint()

func timeoutProcess():
	spawnMonster()
