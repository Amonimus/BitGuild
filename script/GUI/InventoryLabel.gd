extends Sprite

# Pointers
var GameControl

# Loaded values
var value
var itemName

# Params
var isReady = false

# Main
func _ready():
	GameControl = get_tree().current_scene.get_node("GameControl")
	isReady = true

func _process(_delta):
	update()

func _draw():
	GameControl.drawTextCentered(self, Vector2(40, 0), itemName+': '+str(value))
