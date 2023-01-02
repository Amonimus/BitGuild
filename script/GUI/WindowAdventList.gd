extends "res://script/GUI/Window.gd"

# Pointers
var guild

# Params
var adventlabels = []

# Main
func _ready():
	guild = get_tree().current_scene.get_node("Objects/Screen2/Guild")

func _process(_delta):
	for advent in guild.adventList.guild:
		newAdventLabel(advent)

# Methods
func drawContent():
	for adventLabel in adventlabels:
		adventLabel.update()

func newAdventLabel(advent):
	var isNewAdvent = true
	for label in adventlabels:
		if advent == label.targetAdvent:
			isNewAdvent = false
	if isNewAdvent:
		var adventLabel = Label.new()
		adventLabel.set_script(load("res://script/GUI/AdventurerLabel.gd"))
		add_child(adventLabel)
		adventlabels.append(adventLabel)
		adventLabel.targetAdvent = advent
		adventLabel.rect_position = Vector2(-64, -128)
