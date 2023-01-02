extends Sprite

# Pointers
var gameControl
var camera
var label

# Loaded values
var tutorialStrings
var portraits

# Params
var boxHalfSize
var currentText
var textOffset
var tutorialIndex
var queue = []

# Main
func _ready():
	gameControl = get_tree().current_scene.get_node("GameControl")
	tutorialStrings = gameControl.getConfigParam("tutorialStrings")
	portraits = gameControl.getConfigParam("portraits")
	boxHalfSize = Vector2(gameControl.getConfigParam("gameResolutionX")*0.35, gameControl.getConfigParam("gameResolutionY")*0.35)
	camera = get_parent()
	pause_mode = Node.PAUSE_MODE_PROCESS
	z_index = 2
	visible = false
	textOffset = Vector2(8, 8)
	tutorialIndex = 1
	labelSetup()

func _process(_delta):
	var queue_temp = queue.duplicate()
	for message in queue_temp:
		if !visible:
			popup(message[0], message[1])
			queue.erase(message)
	global_position = camera.position+get_viewport_rect().get_center()
	update()
	
func _draw():
	var rect = Rect2(-boxHalfSize, boxHalfSize*2)
	draw_rect(rect, Color(0.15, 0.15, 0.15), true)
	draw_rect(rect, Color(0, 0, 0), false, 4)
	draw_texture(portraits[0], boxHalfSize/3)

func _input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			unpause()

# Methods
func labelSetup():
	label = Label.new()
	add_child(label)
	label.autowrap = true
	label.rect_size = (boxHalfSize-textOffset)*2
	label.rect_position = -boxHalfSize+textOffset

func popup(stack, string):
	match stack:
		"Error":
			label.text = "CRITICAL ERROR\n"
			label.text += string
		"Tutorial":
			label.text = tutorialStrings[string]
		"Custom":
			label.text = string
	visible = true
	get_tree().paused = true

func queueUp(stack, string):
	queue.append([stack, string])

func unpause():
	visible = false
	get_tree().paused = false
