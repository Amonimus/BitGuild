extends Node2D

# Pointers
var inventory
var gameControl
var guild

# Params
var items
var advents
var adventlabels = []

# Main
func _ready():
	gameControl = get_tree().current_scene.get_node("GameControl")
	inventory = get_tree().current_scene.get_node("GameMonitor/GameInventory")
	guild = get_tree().current_scene.get_node("Objects/Screen2/Guild")
	items = gameControl.getConfigParam("items")

func _process(_delta):
	pass
#	for adventLabel in adventlabels:
#		adventLabel.update()

# Methods
#func newAdventLabel(advent):
#	var adventLabel = Label.new()
#	adventLabel.set_script(load("res://script/GUI/AdventurerLabel.gd"))
#	add_child(adventLabel)
#	adventlabels.append(adventLabel)
#	adventLabel.targetAdvent = advent
#	adventLabel.rect_position = Vector2(186, 0)
