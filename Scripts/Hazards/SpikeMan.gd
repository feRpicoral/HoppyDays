extends KinematicBody2D

#Global variables/consts
var motion = Vector2()
const UP = Vector2(0, -1)
var currentSpeed
var onEdge = false

#Editor variables
export var speed = 100
export var random_direction = true
export(String, "Right", "Left") var initial_direction 

#Changes the direction based on the editor settings
func _ready():	
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
	
func _process(delta):
	if not onEdge: updateAnimation(motion)

func _physics_process(delta):
	walk()
	move_and_slide(motion, UP)
	
func walk():
	motion.x = speed	

#Updates the animation based on the motion
func updateAnimation(motion):
	var sprite = $"Spike Man/Sprite"
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
	speed = currentSpeed
	onEdge = false

#About to fall
func _on_sensor_body_exited(body):
	#Avoid walking animation
	onEdge = true
	#Change direction
	speed = speed * -1
	#Save the speed before stoping
	currentSpeed = speed
	
	#Sits for a litte
	var timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(1)
	timer.connect("timeout", self, "move_again")
	add_child(timer)
	speed = 0
	$"Spike Man/Sprite".play("idle")
	timer.start()	
	
	
