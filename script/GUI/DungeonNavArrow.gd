extends "res://script/Classes/TouchButton.gd"

# Pointers
var dungeonGui

# Loaded values
var arrowTexture

# Params
var direction

# Methods
func buttonPressed():
	if direction == "Up":
		dungeonGui.switchDungeonRelative(-1)
	else:
		dungeonGui.switchDungeonRelative(1)

func readyAction():
	dungeonGui = get_tree().current_scene.get_node("Objects/Screen3/DungeonGui")
	if position.x < 0:
		direction = "Up"
		arrowTexture = gameControl.getConfigParam("guiArrowUpTexture")
		texture = arrowTexture
	else:
		direction = "Down"
		arrowTexture = gameControl.getConfigParam("guiArrowDownTexture")
		texture = arrowTexture
