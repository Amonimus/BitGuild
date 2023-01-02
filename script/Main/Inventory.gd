extends Control

# Params
var gameControl
var items = {}

# Main
func _ready():
	gameControl = get_tree().current_scene.get_node("GameControl")
	for item in gameControl.getConfigParam("items"):
		items[item.ItemName] = 0
