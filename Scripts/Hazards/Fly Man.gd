extends KinematicBody2D

#WORKFLOW
#If player triggers the raycast, ACCELERATE to it
#If hit or not, start going down


#Editor variables
export(int) var fly_speed = 1000
export(int) var attack_range = 1000
export(int) var max_fly_height = 600


#Global variables
var motion = Vector2()
const UP = Vector2(0, -1)
const GRAV = 100 

#Initialize some variables
var canAttack = false
var stopedFlying = false
var hitBeforeMax = false
var initialY
var d

func _ready():
	#Set the inital position
	initialY = self.global_position.y
	
	#Set the attack range
	var cast_to = Vector2($RayCast2D.cast_to.x, attack_range)
	$RayCast2D.set_cast_to(cast_to)
	
	$Trigger/Collision.shape.extents.y = attack_range
	$Trigger/Collision.position.y = -attack_range

#Move the fly man
func _physics_process(delta):
	move_and_slide(motion, UP)

func _process(delta):
	
	#Allows delta to be called from other functions
	d = delta

	#Gravity
	fall(delta)

	#Attack if player triggers the Ray Cast
	if $RayCast2D.is_colliding():
		canAttack = true
	elif canAttack:
		attack(delta)

	#Reset variables
	if is_on_floor():
		$Area2D/Sprite.play("idle")
		canAttack = false
		stopedFlying = false
		hitBeforeMax = false
		
#Start flying to hit the player
func attack(delta):
	if self.global_position.y <= initialY - max_fly_height:	
		if not stopedFlying:
			stop_flying(delta)
	else:
		if not hitBeforeMax:
			$Area2D/Sprite.play("fly")
			motion.y += -fly_speed * delta

#Stop flying
func stop_flying(delta):
	$Area2D/Sprite.play("fall")
	#Timer to reset stopedFlying before getting to ground
	var timer = Timer.new()
	timer.set_wait_time(0.1)
	timer.set_one_shot(true)
	timer.connect("timeout", self, "reset_SF")
	add_child(timer)
	
	canAttack = false
	stopedFlying = true
	timer.start()
	motion.y = 0
	

func reset_SF():
	stopedFlying = false

#Gravity effect
func fall(delta):
	if not is_on_floor():
		motion.y += GRAV * delta
	else:
		motion.y = 0
	
#When player touches the fly man
func _on_body_entered(body):
	body.take_damage()
	hitBeforeMax = true
	stop_flying(d)


func _on_trigger(body):
	canAttack = true
