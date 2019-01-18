extends Area2D

#Imports the player and global
# Area2D -> AnimatedSprite -> Node2D (Carrots) -> World -> Player
onready var player = get_parent().get_node("Player")
onready var global = player.get_node("Global")

#Editor variables
export(int) var coins_to_unlock = 0
export(float) var waitTime = 1.5

#Global variables
var showing = false

#Needed. If set in scene, it will bug.
func _ready():
	hide_text()

func _on_body_entered(body):	
	var coins =  global.get("actualCoins")
	if coins >= coins_to_unlock:
		finish_level()
	else:
		if not showing:
			show_text()

#Show text saying that X coins are needed
func show_text():
	showing = true
	var stdText = $TextStandart
	var coinText = $TextAmount
	
	#Update the text
	var neededCoins = coins_to_unlock
	var text = "You need %s coins to finish this level!" % str(neededCoins)
	coinText.text = text
	
	#Show the text
	stdText.set_visible_characters(-1)
	coinText.set_visible_characters(-1)
	
	#Timer to hide the text again
	var timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(5)
	timer.connect("timeout", self, "hide_text")
	add_child(timer)
	timer.start()

#Hide the text
func hide_text():
	$TextStandart.set_visible_characters(0)
	$TextAmount.set_visible_characters(0)
	showing = false
	
#Ends the level
func finish_level():
	#Turn imortal
	global.lifeCount = 100
	global.stopGUI = true
	
	#Play sound
	get_parent().get_node("LevelUp").play()
	
	#If saving coins, save them
	if global.saveCoins: save_coins()

	#Unlocks the level
	unlock_level()
	
	#Go to the levels screen
	levels_screen()
	
	queue_free()
	


#Unlocks the level on the data JSON
func unlock_level():
	var currentLevel = float(get_tree().get_current_scene().filename[-6])
	var data = global.get("data")
	var unlockedLevels = data["levels"]["unlocked"]
	
	if not unlockedLevels.has(currentLevel):
		unlockedLevels.append(currentLevel)
		global.update_data("levels", "unlocked", unlockedLevels, "GoldenCarrot.gd")	

func save_coins():
	var coins = int(player.get_node("Camera2D/GUI/Banner/Coins/CoinCount").text)
	global.update_data("player", "coins", coins, "Player.gd")	

#Go to the levels screen after X time
func levels_screen():
	#The actual function is called from the level script
	#Create a timer
	var timer = Timer.new()
	
	#Configure the timer
	timer.set_one_shot(true)
	timer.set_wait_time(waitTime)
	get_parent().add_child(timer)
	timer.connect("timeout", get_parent(), "exit_level")
	
	#Start the timer
	timer.start()

