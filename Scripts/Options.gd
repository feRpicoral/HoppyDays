extends Control

#TODO: REDO this whole page and make it works

#Set the timer
var timer = Timer.new()

func _ready():
	#Configure the timer
	timer.set_one_shot(true)
	timer.set_wait_time(0.1)
	add_child(timer)


#Back
func back():
	get_tree().change_scene(Global.main_menu)
func _on_Back_pressed():
	timer.connect("timeout",self,"back")
	play_btn_sound()
	timer.start()

#Toggle fullscreen and save settings
func fullScreen():
	var data = Global.get("data")
	var isFullscreen = data["settings"]["fullscreen"]
	if  not isFullscreen:
		#Set fullscreen to true and save settings
		ProjectSettings.set("display/window/size/fullscreen", true)
		Global.update_data("settings", "fullscreen", true, "Options.gd")
		ProjectSettings.save()
		#Needed to set fullscreen until game restarts
		OS.window_fullscreen = true		
	else:
		#Go back to window mode and change the settings
		ProjectSettings.set("display/window/size/fullscreen", false)
		Global.update_data("settings", "fullscreen", false, "Options.gd")
		ProjectSettings.save()
		OS.window_fullscreen = !OS.window_fullscreen
		OS.window_size[0] = 1280
		OS.window_size[1] = 720
		OS.center_window()
func _on_Fullscreen_pressed():
	timer.connect("timeout",self,"fullScreen")
	play_btn_sound()
	timer.start()

#Called to play the click sound
func play_btn_sound():
	$ButtonClickSound.play()
