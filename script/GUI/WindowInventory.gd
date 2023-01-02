extends "res://script/GUI/Window.gd"

# Pointers
var inventory

# Params
var items

# Main
func _ready():
	inventory = get_tree().current_scene.get_node("GameMonitor/GameInventory")
	items = gameControl.getConfigParam("items")
	var yOffest = -164
	for item in items:
		item.Object = newLabel(item)
		item.Object.position.x = -96
		item.Object.position.y = yOffest
		yOffest += 20

# Methods
func drawContent():
	for item in items:
		item.Object.value = inventory.items[item.Object.itemName]

func newLabel(itemDetails):
	var itemLabel = Sprite.new()
	itemLabel.set_script(load("res://script/GUI/InventoryLabel.gd"))
	add_child(itemLabel)
	itemLabel.texture = itemDetails.texture
	itemLabel.itemName = itemDetails.ItemName
	itemLabel.value = 0
	return itemLabel
