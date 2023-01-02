extends Sprite

# Pointers
var dungeonProcessor
var gameControl

# Loaded values
var cameraMoveSpeedMod
var dungeonNavHeight

# Params
var currentDungeon
var dungeonCameraTargetPosition
var dungeonName

# Main
func _ready():
	gameControl = get_tree().current_scene.get_node("GameControl")
	dungeonProcessor = get_parent().find_node("DungeonProcessor")
	cameraMoveSpeedMod = gameControl.getConfigParam("cameraMoveSpeedMod")
	dungeonNavHeight = gameControl.getConfigParam("dungeonNavHeight")
	currentDungeon = 0
	dungeonCameraTargetPosition = 0
	moveToDungeon(currentDungeon)

func _process(_delta):
	if dungeonCameraTargetPosition != position.y:
		moveToPoint()
	update()

func _draw():
	gameControl.drawTextCentered(self, Vector2(0, 0), "D"+String(currentDungeon)+": "+dungeonProcessor.dungeonList[currentDungeon].dungeonName)
	gameControl.drawTextCentered(self, Vector2(0, 16), "PR: "+String(dungeonProcessor.dungeonList[currentDungeon].dungeonPowerRating))

# Methods
func switchDungeonRelative(dun):
	currentDungeon += dun
	if currentDungeon < 0:
		currentDungeon = len(dungeonProcessor.dungeonList)-1
	if currentDungeon >= len(dungeonProcessor.dungeonList):
		currentDungeon = 0
	moveToDungeon(currentDungeon)

func moveToDungeon(dun):
	currentDungeon = dun
	dungeonCameraTargetPosition = -(dun*dungeonNavHeight)
	dungeonName = dungeonProcessor.dungeonList[currentDungeon].dungeonName

func moveToPoint():
	dungeonProcessor.position.y -= (dungeonProcessor.position.y - dungeonCameraTargetPosition) * cameraMoveSpeedMod
	if abs(dungeonCameraTargetPosition - dungeonProcessor.position.y) < 4:
		dungeonProcessor.position.y = dungeonCameraTargetPosition
