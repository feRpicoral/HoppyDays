extends KinematicBody2D

#Global variables/consts
var motion = Vector2()
const UP = Vector2(0, -1)
var current_speed
var on_edge = false

#Editor variables
export(int) var speed = 100
export(bool) var random_direction = true
export(float) var wait_time = 2
export(String, "Right", "Left") var initial_direction 

#Changes the direction based on the editor settings
func _ready():	
	$Timer.wait_time = wait_time

	if random_direction:
		randomize()
		var random_number = randi() % 2
		if random_number == 1:
			pass
		else:
			speed = speed * -1
	else:
		if initial_direction == "Right":
			pass
		else:
			speed = speed * -1
	
func _process(delta):
	if not on_edge: updateAnimation(motion)

func _physics_process(delta):
	motion.x = speed	
	move_and_slide(motion, UP)


#Updates the animation based on the motion
func updateAnimation(motion):
	var sprite = $Area2D/Sprite
	if motion.x > 0:
		sprite.play("walk")
		sprite.flip_h = false
	else:
		sprite.play("walk")
		sprite.flip_h = true

#Player touched the spike man
func _on_Spike_Man_body_entered(body):
	body.take_damage()

func move_again():
	speed = current_speed
	on_edge = false

#About to fall
func _on_sensor_body_exited(body):
	#Avoid walking animation
	on_edge = true
	#Change direction
	speed = speed * -1
	#Save the speed before stoping
	current_speed = speed
	
	#Waits before moving again
	speed = 0
	$Area2D/Sprite.play("idle")
	$Timer.start()	
	
	
