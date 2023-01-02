extends Sprite

# Pointers
var closeButton
var gameControl
var gameCamera

# Params
var boxHalfSize

# Main
func _ready():
	gameControl = get_tree().current_scene.get_node("GameControl")
	boxHalfSize = Vector2(gameControl.getConfigParam("gameResolutionX")*0.35, gameControl.getConfigParam("gameResolutionY")*0.3)
	z_index = 10
	gameCamera = get_tree().current_scene.get_node("Camera")
	closeButton = Sprite.new()
	closeButton.set_script(load("res://script/GUI/ButtonCloseWindow.gd"))
	closeButton.position = Vector2(boxHalfSize.x, -boxHalfSize.y)
	add_child(closeButton)

func _process(_delta):
	global_position = gameCamera.position+get_viewport_rect().get_center()

func _draw():
	var rect = Rect2(-boxHalfSize, boxHalfSize*2)
	draw_rect(rect, Color(0.15, 0.15, 0.15), true)
	draw_rect(rect, Color(0, 0, 0), false, 2)
	drawContent()

# Methods
func close():
	get_parent().window = null
	get_parent().remove_child(self)
	
func drawContent():
	pass
