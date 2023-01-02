extends Label

# Pointers
var gameControl
var targetAdvent

# Params
var isReady = false
var icon = load("res://img/AdventSprites/AdventKnight1.png")

# Main
func _ready():
	gameControl = get_tree().current_scene.get_node("GameControl")
	text = "DEFAULT"
	isReady = true

func _process(_delta):
	update()
	updateStats()

func _draw():
	draw_texture(icon, Vector2(-32,0))

# Methods
func updateStats():
	text = "Status: "+String(targetAdvent.adventState)
	text += "\nPR: "+String(targetAdvent.adventPowerRating)
	text += "\nHealth: "+String(targetAdvent.adventHealth)
	text += "/"+String(targetAdvent.adventMaxHealth)
	text += "\nStrength: "+String(targetAdvent.adventStrengthDefault)
	text += "\nDefense: "+String(targetAdvent.adventDefense)
	text += "\nMorale: "+String(targetAdvent.adventDrunkLevel)
	text += "\nConfidence: "+String(targetAdvent.adventConfidenceLevel)
