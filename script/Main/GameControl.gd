extends Node

# Pointers
var cutscenePlayer
var gameCamera
var gameConfig
var gameFont
var gameInventory
var gameMonitor
var screenGuild

# Main	
func _ready():
	gameConfig = get_parent().get_node("Config")
	gameCamera = get_parent().get_node("Camera")
	gameMonitor = get_parent().get_node("GameMonitor")
	gameInventory = gameMonitor.get_node("GameInventory")
	cutscenePlayer = gameCamera.get_node("CutscenePlayer")
	screenGuild = get_parent().get_node("Objects/Screen2/Guild")
	gameFont = getDefaultFont()
	#Engine.set_time_scale(8.0)

# Methods
func addInventoryItem(item, number):
	if (gameInventory.items[item] + number > 0):
		gameInventory.items[item] += number
		return true
	else:
		return false

func ArbitraryExecution(command):
	var args = command.split(" ")
	match args[0]:
		"PLAY":
			if len(args) == 3:
				cutscenePlayer.queueUp(args[1], args[2])
		"INQURE":
			if len(args) == 3:
				match args[1]:
					"gameMonitor":
						match args[2]:
							"gameStatus":
								return gameMonitor.gameStatus
					"randomAdvent":
						match args[2]:
							"adventState":
								var totalAdvents = screenGuild.adventList.wild + screenGuild.adventList.guild
								if totalAdvents.size() > 0:
									return totalAdvents[randi() % totalAdvents.size()].adventState
								else:
									return null
		"SET":
			if len(args) == 4:
				match args[1]:
					"gameMonitor":
						match args[2]:
							"gameStatus":
								gameMonitor.gameStatus = args[3]
		"GIVE":
			if len(args) == 3:
				addInventoryItem(args[1], int(args[2]))

func drawTextCentered(callingObject, point, string):
	if typeof(string) != TYPE_STRING:
		string = String(string)
	var center = point+Vector2(0, gameFont.get_ascent())
	var textSize = gameFont.get_string_size(string)
	callingObject.draw_string(gameFont, center-(textSize/2), string)

func getConfigParam(param):
	return gameConfig.get(param)

func getConfigSetup(callingObject, params):
	for param in params:
		callingObject.set(param, getConfigParam(param))

func getDefaultFont():
	var label = Label.new()
	var font = label.get_font("")
	label.queue_free()
	return font

func getGlobalMousePositon(event):
	return gameCamera.position+event.position

func moveToPointLinear(callingObject, targetPosition, speed):
	var difference = Vector2(callingObject.position - targetPosition)
	var angle = atan2(difference.y, difference.x)
	callingObject.position -= Vector2(cos(angle)*speed, sin(angle)*speed)
	if callingObject.position.distance_to(targetPosition) < 4:
		callingObject.position = targetPosition
		return true
	else:
		return false

func moveToPointSmooth(callingObject, targetPosition, speed):
	callingObject.position -= (callingObject.position - targetPosition) * speed
	if callingObject.position.distance_to(targetPosition) < 4:
		callingObject.position = targetPosition
		return true
	else:
		return false

func testMouseInTexture(event, callingObject, centered):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed and !get_tree().paused:
			if callingObject.texture != null:
				var offset = Vector2(0, 0)
				if centered:
					offset = callingObject.texture.get_size()/2
				var rect = Rect2(callingObject.global_position-offset, callingObject.texture.get_size())
				return rect.has_point(getGlobalMousePositon(event))
	return false
