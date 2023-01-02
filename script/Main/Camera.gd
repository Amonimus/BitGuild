extends Camera2D

# Pointers
var gameControl
var topBar

# Loaded values
var gameResolutionX
var gameResolutionY
var cameraMoveSpeedMod
var gameMenus

# Params
var cameraTargetPosition
var currentMenuIndex

# Main
func _ready():
	gameControl = get_tree().current_scene.get_node("GameControl")
	gameControl.getConfigSetup(self, [
		"gameResolutionX",
		"gameResolutionY",
		"cameraMoveSpeedMod",
		"gameMenus"
	])
	topBar = get_node("MenuBarTop")
	cameraTargetPosition = position
	setVertical()
	snapToMenu(1)

func _process(_delta):
	gameControl.moveToPointSmooth(self, cameraTargetPosition, cameraMoveSpeedMod)

# Methods
func moveToMenu(menu):
	currentMenuIndex = menu
	cameraTargetPosition.x = menu*gameResolutionX
	topBar.menuName = gameMenus[currentMenuIndex]

func setVertical():
	OS.window_size = Vector2(gameResolutionX, gameResolutionY)
	if OS.has_touchscreen_ui_hint():
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_IGNORE, Vector2(gameResolutionX, gameResolutionY)) 

func snapToMenu(menu):
	currentMenuIndex = menu
	cameraTargetPosition.x = menu*gameResolutionX
	position.x = menu*gameResolutionX
	topBar.menuName = gameMenus[currentMenuIndex]

func switchMenuRelative(menu):
	currentMenuIndex += menu
	if currentMenuIndex < 0:
		currentMenuIndex = len(gameMenus)-1
	if currentMenuIndex >= len(gameMenus):
		currentMenuIndex = 0
	moveToMenu(currentMenuIndex)
