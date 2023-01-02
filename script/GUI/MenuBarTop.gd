extends Sprite

# Pointers
var gameControl

# Loaded values
var menuName

# Main
func _ready():
	gameControl = get_tree().current_scene.get_node("GameControl")
	menuName = "Menu"

func _process(_delta):
	update()
	
func _draw():
	gameControl.drawTextCentered(self, texture.get_size()/2, menuName)
