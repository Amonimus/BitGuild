extends Node

# Params

var achivements = [
	{"name": "TutorialStartup",
	"conditions": [
		["gameMonitor gameStatus", "FirstRun"]
	],
	"rewards": [
		"PLAY Tutorial Tut1String",
		"PLAY Tutorial Tut2String",
		"SET gameMonitor gameStatus SecondScene",
	]
	},
	{"name": "TutorialNewAdvent",
	"conditions": [
		["randomAdvent adventState", "PendingHire"]
	],
	"rewards": [
		"PLAY Tutorial Tut3String",
	]
	},
	{"name": "TutorialTable",
	"conditions": [
		["randomAdvent adventState", "PendingParty"]
	],
	"rewards": [
		"PLAY Tutorial Tut4String",
	]
	},
	{"name": "TutroialLeaving",
	"conditions": [
		["randomAdvent adventState", "PendingDungeon"]
	],
	"rewards": [
		"PLAY Tutorial Tut5String",
	]
	},
	{"name": "TutroialEscape",
	"conditions": [
		["randomAdvent adventState", "Bail"]
	],
	"rewards": [
		"PLAY Tutorial Tut6String",
	]
	},
	{"name": "TutroialDeath",
	"conditions": [
		["randomAdvent adventState", "Defeat"]
	],
	"rewards": [
		"PLAY Tutorial Tut7String",
	]
	},
]
var adventDefenseDefault = 2
var adventDrunkBailBonus = 0.1
var adventDrunkFoodBonus = 0.3
var adventDrunkLevelDefault = 1
var adventDrunkWinBonus = 0.1
var adventHealthDefault = 50.0
var adventMoveSpeedModDefault = 5
var adventRanks = [
	"Wood",
	"Porcelain",
	"Iron",
	"Steel",
	"Bronze",
	"Silver",
	"Gold",
	"Diamond",
	"Platinum",
	"Crystal",
]
var adventResponseTimeoutDefaultGuild = 0.5
var adventScript = preload("res://script/Classes/Adventurer.gd")
var adventStates = {
	"NewAdvent": {"id": 0, "string": "New adventurer."},
	"PendingOutside": {"id": 1, "string": "Arriving soon..."},
	"NewArrival": {"id": 2, "string": "New arrival."},
	"NewGoingToCounter": {"id": 3, "string": "New, going to the counter."},
	"PendingHire": {"id": 4, "string": "Pending hire."},
	"Fired": {"id": 5, "string": "Fired."},
	"NewHired": {"id": 6, "string": "A new recruit."},
	"GoingToBar": {"id": 7, "string": "Going to the bar."},
	"PendingParty": {"id": 8, "string": "Drinking and assembling party."},
	"LeavingToDungeon": {"id": 9, "string": "Leaving for the dungeon."},
	"Deploying": {"id": 10, "string": "Deploying..."},
	"PendingDungeon": {"id": 11, "string": "Seeking dungeon..."},
	"DungeonArrival": {"id": 12, "string": "Arrived to dungeon."},
	"DungeonStop": {"id": 13, "string": "In dungeon, thinking."},
	"DungeonIdle": {"id": 14, "string": "In dungeon, walking idly."},
	"HuntingMonster": {"id": 15, "string": "In dungeon, chasing monster."},
	"InCombat": {"id": 16, "string": "In dungeon, in combat!"},
	"CombatCelebrate": {"id": 17, "string": "In dungeon, successful batte!"},
	"Defeat": {"id": 18, "string": "In dungeon, knocked out!"},
	"Recovering": {"id": 19, "string": "Recovering at inn..."},
	"Recovered": {"id": 20, "string": "Recovered and at full health."},
	"Bail": {"id": 21, "string": "Has panicked in the dungeon."},
	"Escaping": {"id": 22, "string": "Fleeing dungeon..."},
	"ReturningFromMission": {"id": 23, "string": "Returning to the guild..."},
	"ArrivedFromMission": {"id": 24, "string": "Arrived from a mission."},
	"GoingToRest": {"id": 25, "string": "Wants to sleep..."},
}
var adventStatusIcons = {
	"Attention": preload("res://img/StatusIcons/StatusIconAttention.png"),
	"Death": preload("res://img/StatusIcons/StatusIconDeath.png"),
	"Fighting": preload("res://img/StatusIcons/StatusIconFighting.png"),
	"Sleeping": preload("res://img/StatusIcons/StatusIconSleeping.png"),
	"Waiting": preload("res://img/StatusIcons/StatusIconWaiting.png"),
	"Happy": preload("res://img/StatusIcons/StatusIconHappy.png"),
	"Sad": preload("res://img/StatusIcons/StatusIconSad.png"),
}
var adventStrengthDefault = 25
var adventTexture = preload("res://img/AdventSprites/AdventKnight2.png")
var cameraMoveSpeedMod = 0.2
var dungeonNavHeight = 320
var dungeonMonsterMax = 5
var dungeonMonsterScript = preload("res://script/Classes/Monster.gd")
var dungeonScript = preload("res://script/Classes/Dungeon.gd")
var dungeonSpawnTimeout = 1 #5
var dungeonWallOffset = 32
var dungeons = {
	"D1": {
		"name": "Slime Forest",
		"texture": preload("res://img/Backgrounds/DungeonBackground.png"),
		"monster": "M1"},
	"D2": {
		"name": "The Sewers",
		"texture": preload("res://img/Backgrounds/DungeonBackground.png"),
		"monster": "M2"},
	"D3": {
		"name": "Abandoned warehouse",
		"texture": preload("res://img/Backgrounds/DungeonBackground.png"),
		"monster": "M2"},
	"D4": {
		"name": "Cursed graveyard",
		"texture": preload("res://img/Backgrounds/DungeonBackground.png"),
		"monster": "M2"},
	"D97": {
		"name": "Demon Castle Gates",
		"texture": preload("res://img/Backgrounds/DungeonBackground.png"),
		"monster": "M2"},
	"D98": {
		"name": "Demon Castle Grounds",
		"texture": preload("res://img/Backgrounds/DungeonBackground.png"),
		"monster": "M2"},
	"D99": {
		"name": "The Throne Room",
		"texture": preload("res://img/Backgrounds/DungeonBackground.png"),
		"monster": "M2"},
}
var gameMenus = ["Settings", "Guild", "Dungeon"]
var gameResolutionX = 360
var gameResolutionY = 640
var gameVersion = "0.01"
var guiArrowDownTexture = preload("res://img/Buttons/ArrowDown.png")
var guiArrowRightTexture = preload("res://img/Buttons/ArrowRight.png")
var guiArrowLeftTexture = preload("res://img/Buttons/ArrowLeft.png")
var guiArrowUpTexture = preload("res://img/Buttons/ArrowUp.png")
var guildMaxAdvents = 1
var items = [
	{"ItemName": "Gold", "texture": load("res://img/ItemSprites/ItemIconGold.png")},
	{"ItemName": "Slime", "texture": load("res://img/ItemSprites/ItemIconSlime.png")},
	{"ItemName": "Food", "texture": load("res://img/ItemSprites/ItemIconFood.png")},
]
var monsterDefense = 5
var monsterLoot = {"Slime": 1}
var monsterMaxHealth = 20.0
var monsterMoveTimer = 1
var monsterMoveSpeedMod = 0.5
var monsterName = "Slime"
var monsterPower = 10
var monsterTexture = preload("res://img/MonsterSpirtes/MonsterSlime.png")
var monsters = {
	"M1": {
		"name": "Slime",
		"texture": preload("res://img/MonsterSpirtes/MonsterSlime.png"),
		"strength": 10.0,
		"maxHealth": 20.0,
		"defense": 5,
	},
	"M2": {
		"name": "Fat Slime",
		"texture": preload("res://img/MonsterSpirtes/MonsterSlime.png"),
		"strength": 20.0,
		"maxHealth": 100.0,
		"defense": 15,
	},
}
var portraits = [preload("res://img/GUI/PortraitVanessa.png")]
var tutorialStrings = {
	"Tut1String":
	"Gee, it sure is boring around here. I've built a castle near this kingdom, and the only ones to challenge me, occasionally, were some third-degree losers. Are there no legenday heroes in this land? There are tons of monsters around, but nobody is grinding, decrease their population enough to not be a threat and go home. How can I get them to kill non-stop to get stronger? Do I have to pay them? With what money? I don't have much of the local currency. Well, I guess I can set something up...",
	"Tut2String":
	"I've been doing some pre-work in my human disguise. These villagers are so stupid, with just a charming face and superior knowledge, and I was given this abandoned tavern for free. Now I just have to put a billboard and provoke random hero wannabes to risk their lives. If I manage to sell food and any materials they get, I'll be able to offer more tempting rewards. Well, here goes nothing.",
	"Tut3String":
	"Look at this shmuck. Can't do the hard work, so he just asks around looking for an easy job. He's probably not cut for a hero, but if I can convince him that killing local monsters is a piece of cake, he'll talk about this place elsewhere and bring better customers. For now let's hire him. Tap on an adventurer in the queue to initiate them into the guild.",
	"Tut4String":
	"I take they just can't work on an empty stomach. Then again, each of them may be their last supper, and I'm still getting small income from them. And it's easier to convincem to go to more dangerous areas if they're drunk. Before deploying, they fill themselves with whatever I can offer, team up if possible, weight their chances and seek the best dungeon for them.",
	"Tut5String":
	"And off he goes. He should be arriving in the Slime Forest shortly and start poking everything in sight.",
	"Tut6String":
	"Humans are natural cowards. They'll always try to flee when odds aren't in their favor. If they're too tired they'll just leave for the guild to recharge. The morale of the adventurers increases with every victory, so the more they kill weaker enemies the more overconfident they get until the fate decides to finally show up. But that's where my very special wine comes in, it helps boost their morale faster so they'd throw themselves at risk sooner. Let's see how it goes.",
	"Tut7String":
	"Ah, Memento Mori. Well, it would be pretty bad if the rumors start spreading of dead rookies, so let me drag them to the guild and give them some first aid. And it's a great opportunity to loot them and they would never know.",
}

# Methods
func loadFile(filePath):
	var file = File.new()
	file.open(filePath, File.READ)
	var content = file.get_as_text()
	file.close()
	return content
