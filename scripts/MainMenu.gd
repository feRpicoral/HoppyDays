extends Control

#Timer is needed to the button sound be heard

onready var timer = $Timer

#Quit
func close():
	get_tree().quit()	
func _on_Quit_pressed():
	timer.connect("timeout",self,"close")
	play_btn_sound()
	timer.start()	
	
	
#Options
func options():
	get_tree().change_scene(Global.UI_options)
func _on_Options_pressed():
	timer.connect("timeout",self,"options")
	play_btn_sound()
	timer.start()
	
		
#Continue from the last level unlocked
func _continue():
	var data = Global.data
	
	#Checks if isn't the first time playing
	if data["levels"]["current"] == null:
		get_tree().change_scene(Global.levels_folder + "Level1.tscn")
	else:
		var current_level = String(data["levels"]["current"])
		var level_to_load = Global.levels_folder + "Level" + current_level + ".tscn"
		get_tree().change_scene(level_to_load)
func _on_Continue_pressed():
	timer.connect("timeout",self,"_continue")
	play_btn_sound()
	timer.start()
	

#Goes to the levels menu
func levels():
	get_tree().change_scene(Global.UI_levels)
func _on_Levels_pressed():
	timer.connect("timeout",self,"levels")
	play_btn_sound()
	timer.start()		

#Called to play the click sound
func play_btn_sound():
	$ButtonClickSound.play()
