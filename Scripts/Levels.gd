extends Control

#Set the timer
var timer = Timer.new()

func _ready():
	#Configure the timer
	timer.set_one_shot(true)
	timer.set_wait_time(0.1)
	add_child(timer)

#Back
func back():
	get_tree().change_scene("res://Scenes/UI/MainMenu.tscn")
func _on_Back_pressed():
	timer.connect("timeout",self,"back")
	play_btn_sound()
	timer.start()
	

#Called to play the click sound
func play_btn_sound():
	$ButtonClickSound.play()