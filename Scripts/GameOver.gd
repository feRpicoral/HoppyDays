extends Control


onready var timer = $Timer

#Quit
func close():
	get_tree().quit()
func _on_Quit_pressed():
	timer.connect("timeout",self,"close")
	play_btn_sound()
	timer.start()

#Main Menu
func mainMenu():
	get_tree().change_scene(Global.main_menu)
func _on_Menu_pressed():
	timer.connect("timeout",self,"mainMenu")
	play_btn_sound()
	timer.start()

#Try Again
func tryAgain():
	get_tree().change_scene(Global.last_level_played)
func _on_TryAgain_pressed():
	timer.connect("timeout",self,"tryAgain")
	play_btn_sound()
	timer.start()

#Called to play the click sound
func play_btn_sound():
	$ButtonClickSound.play()
