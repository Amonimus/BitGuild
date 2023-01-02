extends "res://script/Classes/TouchButton.gd"

var window

# Main
func _draw():
	pass

# Methods
func readyAction():
	texture = load("res://img/Buttons/ButtonQuit.png")

func buttonPressed():
	get_parent().close()
