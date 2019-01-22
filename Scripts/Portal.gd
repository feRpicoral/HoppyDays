extends Area2D

onready var player = Global.player

var triggered = false

#Editor variables
export(int) var coins_to_unlock = 0
export(float) var end_delay = 1.5

func _ready():
	$LevelsTimer.wait_time = end_delay

func _on_body_entered(body):
	if not triggered:	
		if player.coins >= coins_to_unlock:
			finish_level()
		else:
			show_text()

func show_text():	
	$TextAmount.text = "You need %s coins to finish this level!" % str(coins_to_unlock)
	
	#Shows the text
	$TextStandart.show()
	$TextAmount.show()
	
	$TextTimer.start()

func hide_text():
	$TextStandart.hide()
	$TextAmount.hide()
	
func finish_level():
	triggered = true
	
	#Turn imortal
	Global.stop_gui = true	
	player.lives = 100
	
	#Play sound
	get_parent().get_node("LevelUp").play()
	
	#If saving coins, save them
	if Global.save_coins: save_coins()

	#Adds the level to the data json
	unlock_level()
	
	#Timer to go to the levels screen
	$LevelsTimer.start()
	
	#Hides the portal
	self.hide()
	

#Unlocks the level on the data JSON
func unlock_level():
	var current_level = float(get_tree().get_current_scene().filename[-6])
	var unlocked_levels = Global.data["levels"]["unlocked"]
	
	if not unlocked_levels.has(current_level):
		unlocked_levels.append(current_level)
		Global.update_data("levels", "unlocked", unlocked_levels, "Portal.gd")	

func save_coins():
	Global.update_data("player", "coins", player.coins, "Portal.gd")	

#Go to the levels screen after the delay
func levels_screen():
	get_tree().change_scene(Global.UI_levels)

