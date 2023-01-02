extends "res://script/Classes/TouchButton.gd"

# Main
func _draw():
	gameControl.drawTextCentered(self, Vector2(0, texture.get_size().y), "Reset")

# Methods
func readyAction():
	pass

func buttonPressed():
	get_tree().reload_current_scene()
