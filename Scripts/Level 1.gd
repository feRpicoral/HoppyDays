extends Node

func _ready():	
	#Apply the camera limit for the level
	var camera = $Player/Camera2D
	camera.limit_left = $Player.left_limit
	camera.limit_bottom = $Player.bottom_limit
	if not $Player.infiniteTop: camera.limit_top = $Player.top_limit
	
	#Set this as the last scene
	Global.last_scene()
	
	#Set this as the current level
	set_current_level()
	
func set_current_level():
	var currentLevel = float(get_tree().get_current_scene().filename[-6])
	Global.update_data("levels", "current", currentLevel, "Level %s.gd" % currentLevel)

#Called from GoldCarrot.gd
func exit_level():
	get_tree().change_scene("res://Scenes/UI/Levels.tscn")
