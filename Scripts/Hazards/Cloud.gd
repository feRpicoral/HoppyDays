extends KinematicBody2D

#Editor variables
export(float) var rayCastLenght = 3000.0
export(float) var reloadTime = 5.0
export(String, "800", "400", "200") var animation
export(bool) var usePhysics = false
export(int) var speed = 160
export var random_direction = true
export(String, "Right", "Left") var initial_direction 

#Global variables
var motion = Vector2()
var currentSpeed
var can_attack = true

#Moves the cloud
func _physics_process(delta):
	motion.x = speed
	if usePhysics: move_and_slide(motion)

func _ready():
	if usePhysics:
		$Sprite/AnimationPlayer.stop()
	else:
		$Sprite/AnimationPlayer.play(animation)
	
	#Set a random start direction
	set_random_direction()
	
	#Set the cast Y
	var cast_to = Vector2($Sprite/RayCast2D.cast_to.x, rayCastLenght)
	$Sprite/RayCast2D.set_cast_to(cast_to)
	
	#Set the coold down time
	$Sprite/Timer.set_wait_time(reloadTime)

#If player is underneath the cloud, attack
func _process(delta):
	if $Sprite/RayCast2D.is_colliding() and can_attack:
		attack()

func attack():
	#Spawn the lightning
	var lightning = load("res://Scenes/Enemies/Lighting.tscn")
	var child = lightning.instance()
	$Sprite.add_child(child)
	
	#Start the cool down time
	$Sprite/Timer.start()
	can_attack = false

#Unlocks the attack after the reload time
func _on_Timer_timeout():
	can_attack = true
	
func set_random_direction():
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

func _on_sensor_trigger(body):
	if usePhysics:
		print("sensor")
		if body.get_collision_layer() != 1:
			speed = speed * -1

#Avoids attacking if the player is on the cloud
func _on_CloudArea_body_entered(body):
	can_attack = false
	$Sprite/CloudArea/Timer.start()

func _on_timer_timeout():
	can_attack = true
