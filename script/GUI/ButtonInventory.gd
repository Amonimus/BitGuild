extends "res://script/Classes/TouchButton.gd"

# Params
var window

# Main
func _draw():
	gameControl.drawTextCentered(self, Vector2(0, texture.get_size().y), "Inventory")

# Methods
func buttonPressed():
	if window == null:
		window = Sprite.new()
		window.set_script(load("res://script/GUI/WindowInventory.gd"))
		add_child(window)

func readyAction():
	pass
