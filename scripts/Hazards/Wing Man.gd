extends KinematicBody2D

#Global variables/consts
var motion = Vector2()
const UP = Vector2(0, -1)

#Editor variables
export(int) var speed = 150
export var random_direction = true
export(String, "Right", "Left") var initial_direction
export(int) var max_move_distance = 400
export(float) var wait_time = 2

#Variables
var initial_position
var just_stopped = false
var current_speed

#Changes the direction based on the editor settings
func _ready():
	$PatrolTimer.wait_time = wait_time
	
	#Save the position
	initial_position = self.global_position

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

	motion.x = speed


func _physics_process(delta):
	walk()
	move_and_slide(motion, UP)

func walk():
	if not just_stopped:
		var init_x = initial_position.x
		var max_move = max_move_distance
		var posX = self.position.x

		if posX <= init_x - max_move or posX >= init_x + max_move:
			just_stopped = true
			current_speed = speed
			speed = 0
			$PatrolTimer.start()

	motion.x = speed

func reset_just_stopped():
	just_stopped = false

func move_again():
	$JustStoppedTimer.start()
	speed = current_speed * -1

func _on_body_entered(body):
	body.take_damage()
	
func _on_sensor_trigger(body):
	speed = speed * -1
