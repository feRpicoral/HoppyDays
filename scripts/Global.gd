extends Node2D

#Paths
var main_menu = "res://scenes/gui/MainMenu.tscn"
var levels_folder = "res://levels/"
var UI_levels = "res://scenes/gui/Levels.tscn"
var UI_options = "res://scenes/gui/Options.tscn"
var data_json = "res://data/player-data.JSON"
var lightning = "res://scenes/enemies/Lightning.tscn"

#Nodes
var player
var last_level_played
var bottom_limit

#Settings
var save_coins = false
var stop_gui = false

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
	_load_game_data()

#Loads the JSON 
func _load_game_data():
	var file = File.new()
	file.open(data_json, file.READ)
	data = parse_json(file.get_as_text())
	file.close()

#Saves the game data from and dic
func save_game(data):
	var file = File.new()
	file.open(data_json, file.WRITE)
	file.store_line(to_json(data))
	file.close()
