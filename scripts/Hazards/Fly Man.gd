extends KinematicBody2D

#Editor variables
export(int) var fly_speed = 1000
export(bool) var gravity_proportional = false #Proportional to fly height
export(int) var gravity = 500
export(int) var attack_range = 1000
export(bool) var only_attack_on_viewport = true
export(int) var max_fly_height = 600

#Variables
var motion = Vector2()
const UP = Vector2(0, -1)

var can_attack = false
var stopped_flying = false
var hit_before_max = false
var init_y
var _delta

func _ready():
	#Set the gravity
	if gravity_proportional:
		gravity = fly_speed/2
	
	#Set the inital position
	init_y = self.global_position.y
	
	#Set the trigger size
	$Trigger/Collision.shape.extents.y = attack_range
	$Trigger/Collision.position.y = -attack_range

func _physics_process(delta):
	move_and_slide(motion, UP)

func _process(delta):
	#Allows delta to be called from other functions
	_delta = delta
	
	fall(delta)
	
	if can_attack:
		attack(delta)

	if is_on_floor():
		$Area2D/Sprite.play("idle")
		can_attack = false
		stopped_flying = false
		hit_before_max = false

#Allows the attack
func _on_trigger(body):
	can_attack = true
	
#Start flying to hit the player
func attack(delta):
	if self.global_position.y <= init_y - max_fly_height:	
		if not stopped_flying:
			stop_flying(delta)
	else:
		if not hit_before_max:
			$Area2D/Sprite.play("fly")
			motion.y += -fly_speed * delta

#Stop flying
func stop_flying(delta):
	motion.y = 0	
	$Area2D/Sprite.play("fall")	
	can_attack = false
	stopped_flying = true	
	$StoppedFlyingTimer.start()	

func reset_stopped_flying():
	stopped_flying = false

func fall(delta):
	if not is_on_floor():
		motion.y += gravity * delta
	else:
		motion.y = 0
	
func _on_body_entered(body):
	body.take_damage()	
	if not is_on_floor():
		hit_before_max = true
	stop_flying(_delta)

func _on_screen_exited():
	if only_attack_on_viewport:
		$Trigger/Collision.disabled = true

func _on_screen_entered():
	if only_attack_on_viewport:
		$Trigger/Collision.disabled = false
