extends Control

#Set the timer
onready var timer = $Timer

#Back
func back():
	get_tree().change_scene(Global.main_menu)
func _on_Back_pressed():
	play_btn_sound()
	timer.start()

#Called to play the click sound
func play_btn_sound():
	$ButtonClickSound.play()