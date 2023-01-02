extends Node

# Pointers
var gameControl

# Params
var enable
var achivements
var gameStatus

# Main
func _ready():
	randomize()
	gameControl = get_tree().current_scene.get_node("GameControl")
	achivements = gameControl.getConfigParam("achivements")
	enable = true
	gameStatus = "FirstRun"

func _process(_delta):
	if enable:
		for achievement in achivements:
			if not "flag" in achievement:
				achievement["flag"] = false
			if achievement.flag == false:
				for condition in achievement.conditions:
					if gameControl.ArbitraryExecution("INQURE "+condition[0]) == condition[1]:
						achievement.flag = true
						for reward in achievement.rewards:
							gameControl.ArbitraryExecution(reward)

# Methods
