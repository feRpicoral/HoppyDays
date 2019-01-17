extends KinematicBody2D

const SPEED = 500
var motion = Vector2(0, SPEED)
var posX

#Makes that the lightning does not follow the parent in x pos
func _ready():
	posX = global_position.x

func _process(delta):
	global_position.x = posX

#Remove when not on screen
func _on_screen_exited():
	queue_free()

#Moves the lightning
func _physics_process(delta):
	move_and_slide(motion)

#Handles hit
func _on_hit(body):
	if body.get_collision_layer() == 1:
		#Hit the player
		body.take_damage()
		queue_free()
	if body.get_collision_layer() == 2:
		#Hit the terraint
		queue_free()

