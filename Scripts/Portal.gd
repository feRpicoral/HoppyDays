extends Area2D

#Imports the player and global
# Area2D -> AnimatedSprite -> Node2D (Carrots) -> World -> Player
onready var player = get_parent().get_node("Player")
onready var global = player.get_node("Global")
export var waitTime = 1.5


func _on_body_entered(body):	
	
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

