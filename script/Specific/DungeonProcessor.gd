extends Sprite

# Pointers
var gameControl

# Loaded values
var dungeonNavHeight
var dungeonScript
var dungeons
var monsters

# Params
var dungeonList = []

# Main
func _ready():
	gameControl = get_tree().current_scene.get_node("GameControl")
	dungeonScript = gameControl.getConfigParam("dungeonScript")
	dungeons = gameControl.getConfigParam("dungeons")
	monsters = gameControl.getConfigParam("monsters")
	dungeonNavHeight = gameControl.getConfigParam("dungeonNavHeight")
	newDungeon("D1")
	newDungeon("D2")
	newDungeon("D3")
	newDungeon("D4")
	var yOffest = 256+32
	for dun in dungeonList:
		dun.position.x = 180
		dun.position.y = yOffest
		yOffest += 256+64

# Methods
func newDungeon(index):
	var newDungeon = Sprite.new()
	newDungeon.set_script(dungeonScript)
	newDungeon.texture = dungeons[index].texture
	newDungeon.dungeonName = dungeons[index].name
	newDungeon.dungeonMonster = monsters[dungeons[index].monster]
	add_child(newDungeon)
	dungeonList.append(newDungeon)
