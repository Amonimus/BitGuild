extends Sprite

# Pointers
var gameControl

# Params
var isPressed = false

# Main
func _ready():
	gameControl = get_tree().current_scene.get_node("GameControl")
	readyAction()
	
func _input(event):
	if gameControl.testMouseInTexture(event, self, true) and !isPressed:
		isPressed = true
		buttonPressed()
	else:
		isPressed = false

# Methods
func buttonPressed():
	pass
	
func readyAction():
	pass
