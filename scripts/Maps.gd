extends Node

#Standart script for all maps

export(float) var bottom_limit = 3000.0
export(float) var left_limit = 0.0
export(float) var top_limit = -1500.0
export(bool) var infinite_top = true

func _ready():	
	Global.bottom_limit = bottom_limit
	
	#Apply the camera limit for the level
	var camera = Global.player.get_node("Camera2D")
	camera.limit_left = left_limit
	camera.limit_bottom = bottom_limit
	if not infinite_top: camera.limit_top = top_limit
	
	Global.last_level_played = get_tree().get_current_scene().filename
	
	#Set this as the current level
	set_current_level()
	
func set_current_level():
	var current_level = float(get_tree().get_current_scene().filename[-6])
	Global.update_data("levels", "current", current_level, "Level %s.gd" % current_level)

#Called from GoldCarrot.gd
func exit_level():
	get_tree().change_scene(Global.UI_levels)
