extends Node

#Initialize some variables
onready var lastScene
onready var lifeCount
onready var actualCoins = 0
onready var saveCoins = false
onready var stopGUI = false
onready var canResetMotionY = true

#Data to be saved. May be edited from other scripts
var data = {
	"player": {
		"coins":0,
		"models": ["pink", "brown"],
		"model":"pink"
	},
	"settings": {
		"fullscreen":false,
		"resolution":[1920, 1080]		
	},
	"levels": {
		"current":1,
		"unlocked":[1]
	}
}

#Called from other scripts to update data to be stored
func update_data(key, subKey, value, sender=null):
	if not data.has(key) or not data[key].keys().has(subKey):
		print("ERROR [%s]: Invalid key/value, unable to update data" % sender)
	else:
		data[key][subKey] = value
		save_game(data)
		print("SAVE [%s]: Game saved with success!" % sender)

func _ready():
	#OS.window_resizable = false
	_load_game_data()

#Set the current scene as last scene. Must be called on ready of all levels
func last_scene():
	lastScene = get_tree().get_current_scene().filename

#Loads the JSON 
func _load_game_data():
	var file = File.new()
	file.open("res://Data/player-data.JSON", file.READ)
	data = parse_json(file.get_as_text())
	file.close()

#Saves the game data from and dic
func save_game(data):
	var file = File.new()
	file.open("res://Data/player-data.JSON", file.WRITE)
	file.store_line(to_json(data))
	file.close()
