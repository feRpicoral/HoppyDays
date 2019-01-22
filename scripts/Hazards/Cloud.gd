extends KinematicBody2D

#Editor variables
export(float) var attack_range = 3000.0
export(float) var reload_time = 5.0
export(String, "800", "400", "200") var animation
export(bool) var use_physics = false
export(int) var speed = 160
export var random_direction = true
export(String, "Right", "Left") var initial_direction 

#Global variables
var motion = Vector2()
var current_speed
var can_attack = true

#Moves the cloud
func _physics_process(delta):
	motion.x = speed
	if use_physics: move_and_slide(motion)

func _ready():
	if use_physics:
		$Sprite/AnimationPlayer.stop()
	else:
		$Sprite/AnimationPlayer.play(animation)
	
	set_random_direction()
	
	$Sprite/RayCast2D.cast_to.y = attack_range
	
	$Sprite/Timer.wait_time = reload_time

#If player is underneath the cloud, attack
func _process(delta):
	if $Sprite/RayCast2D.is_colliding() and can_attack:
		attack()

func attack():
	#Spawn the lightning
	var lightning = load(Global.lightning)
	$Sprite.add_child(lightning.instance())
	
	#Start the cool down time
	$Sprite/Timer.start()
	can_attack = false

#Unlocks the attack after the reload time
func _on_Timer_timeout():
	can_attack = true
	
func set_random_direction():
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

func _on_sensor_trigger(body):
	if use_physics:
		if body.get_collision_layer() != 1:
			speed = speed * -1

#Avoids attacking if the player is on the cloud
func _on_CloudArea_body_entered(body):
	can_attack = false
	$Sprite/CloudArea/Timer.start()

func _on_timer_timeout():
	can_attack = true

func _on_CloudArea_body_exited(body):
	can_attack = true
	
