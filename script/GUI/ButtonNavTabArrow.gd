extends "res://script/Classes/TouchButton.gd"

# Pointers
var camera

# Loaded values
var arrowTexture

# Params
var direction

# Methods
func buttonPressed():
	if direction == "Left":
		camera.switchMenuRelative(-1)
	else:
		camera.switchMenuRelative(1)

func readyAction():
	camera = get_tree().current_scene.get_node("Camera")
	if position.x > gameControl.getConfigParam("gameResolutionX")/2:
		direction = "Right"
		arrowTexture = gameControl.getConfigParam("guiArrowRightTexture")
		texture = arrowTexture
	else:
		direction = "Left"
		arrowTexture = gameControl.getConfigParam("guiArrowLeftTexture")
		texture = arrowTexture
