extends KinematicBody2D

#Global variables/consts
var motion = Vector2()
const UP = Vector2(0, -1)

#Editor variables
export var speed = 150
export var random_direction = true
export(String, "Right", "Left") var initial_direction
export(int) var max_move_distance = 400
export(float) var waitTime = 2

#Variables
var initial_position
var just_stopped = false
var timer = Timer.new()
var JS_timer = Timer.new()
var currentSpeed

#Changes the direction based on the editor settings
func _ready():
	#Save the position
	initial_position = self.global_position

	if random_direction:
		randomize()
		var randomNumber = randi() % 2
		if randomNumber == 1:
			pass
		else:
			speed = speed * -1
	else:
		if initial_direction == "Right":
			pass
		else:
			speed = speed * -1

	motion.x = speed

	#Configure the timers
	timer.set_one_shot(true)
	timer.set_wait_time(waitTime)
	timer.connect("timeout", self, "move_again")
	add_child(timer)

	JS_timer.set_one_shot(true)
	JS_timer.set_wait_time(0.1)
	JS_timer.connect("timeout", self, "reset_just_stopped")
	add_child(JS_timer)

func _physics_process(delta):
	walk()
	move_and_slide(motion, UP)

func walk():
	if not just_stopped:
		var initialX = initial_position.x
		var mxMove = max_move_distance
		var posX = self.position.x

		if posX <= initialX - mxMove or posX >= initialX + mxMove:
			just_stopped = true
			currentSpeed = speed
			speed = 0
			timer.start()

	motion.x = speed

#Reset just_stopped
func reset_just_stopped():
	just_stopped = false

#Allow to move after the timer
func move_again():
	JS_timer.start()
	speed = currentSpeed * -1


#Player touched the wing man
func _on_body_entered(body):
	body.take_damage()

#Touched something, change direction
func _on_sensor_trigger(body):
	speed = speed * -1
