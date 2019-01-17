extends Control

#Set the timer
var timer = Timer.new()

func _ready():
	#Configure the timer
	timer.set_one_shot(true)
	timer.set_wait_time(0.1)
	add_child(timer)
	
	
#Quit
func close():
	get_tree().quit()
func _on_Quit_pressed():
	timer.connect("timeout",self,"close")
	play_btn_sound()
	timer.start()	
	
	
#Options
func options():
	get_tree().change_scene("res://Scenes/UI/Options.tscn")
func _on_Options_pressed():
	timer.connect("timeout",self,"options")
	play_btn_sound()
	timer.start()
	
		
#Continue from the last level unlocked
func _continue():
	var data = Global.get("data")
	
	#Checks if isn't the first time playing
	if data["levels"]["current"] == null:
		get_tree().change_scene("res://Scenes/Levels/Level 1.tscn")
	else:
		var levelsDir = "res://Scenes/Levels/Level " #Watch out the space!
		var currentLevel = String(data["levels"]["current"])
		var currentScene = levelsDir + currentLevel + ".tscn"
		get_tree().change_scene(currentScene)
func _on_Continue_pressed():
	timer.connect("timeout",self,"_continue")
	play_btn_sound()
	timer.start()
	

#Goes to the levels menu
func levels():
	get_tree().change_scene("res://Scenes/UI/Levels.tscn")
func _on_Levels_pressed():
	timer.connect("timeout",self,"levels")
	play_btn_sound()
	timer.start()		

#Called to play the click sound
func play_btn_sound():
	$ButtonClickSound.play()
