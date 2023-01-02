extends Sprite

# Pointers
var gameControl
var gameInventory
var guildGui
var guildTimer

# Loaded values
var guildMaxAdvents
var adventScript

# Params
var adventList = {"wild": [], "guild": []}

# Main
func _ready():
	gameControl = get_tree().current_scene.get_node("GameControl")
	gameControl.getConfigSetup(self, ["guildMaxAdvents", "adventScript"])
	gameInventory = get_tree().current_scene.get_node("GameMonitor/GameInventory")
	guildGui = get_tree().current_scene.get_node("Objects/Screen2/S2MenuBarTop/GuildGUI") 
	gameControl.addInventoryItem("Gold", 13)
	gameControl.addInventoryItem("Food", 10)
	setTimer()

# Methods
func setTimer():
	guildTimer = Timer.new()
	guildTimer.connect("timeout", self, "timeoutProcess")
	guildTimer.wait_time = 1
	guildTimer.one_shot = true
	add_child(guildTimer)
	guildTimer.start()

func spawnAdvent():
	var advent = Sprite.new()
	advent.set_script(adventScript)
	add_child(advent)
	adventList.wild.append(advent)

func timeoutProcess():
	if len(adventList.wild)+len(adventList.guild) < guildMaxAdvents:
		spawnAdvent()

func hireAdvent(advent):
	adventList.wild.erase(advent)
	adventList.guild.append(advent)
#	guildGui.newAdventLabel(advent)
