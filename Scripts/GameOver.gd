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

#Main Menu
func mainMenu():
	get_tree().change_scene("res://Scenes/UI/MainMenu.tscn")
func _on_Menu_pressed():
	timer.connect("timeout",self,"mainMenu")
	play_btn_sound()
	timer.start()

#Try Again
func tryAgain():
	var lastScene = Global.get("lastScene")
	get_tree().change_scene(lastScene)
func _on_TryAgain_pressed():
	timer.connect("timeout",self,"tryAgain")
	play_btn_sound()
	timer.start()

#Called to play the click sound
func play_btn_sound():
	$ButtonClickSound.play()
