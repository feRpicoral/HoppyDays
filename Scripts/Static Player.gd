extends KinematicBody2D

#TODO
#Separate in multiple scripts
#Player.gd is doing too much for a single script

#Player Variables / Consts
var motion = Vector2()
const JUMP_HEIGHT = -1000
const SPEED = 800
const GRAVITY = 1500
const JUMP_BOOST = 1.5

func _ready():
	var skin = Global.data["player"]["model"]
	$Sprite.load_skin(skin)

#Move the player
func _physics_process(delta):
	update_motion(delta)

#Change the state of the player
func update_motion(delta):
	fall(delta)
	jump()	
	move_and_slide(motion, Vector2(0, -1))

#Makes sure the right animation is playing
func _process(delta):
	update_animation(motion)

#Changes the animation based on the motion
func update_animation(motion):
	$Sprite.update(motion)


func fall(delta):
	if  is_on_floor():
		motion.y = 0
	else:
		motion.y += GRAVITY * delta
	
	motion.y = clamp(motion.y, (JUMP_HEIGHT * JUMP_BOOST), -JUMP_HEIGHT)


func jump():
	if is_on_floor():
		motion.y = JUMP_HEIGHT

#Change the skin if clicked	
func _on_Button_pressed():
	var skin = Global.data["player"]["model"]
	if skin == "brown":
		$Sprite.load_skin("pink")
	else:
		$Sprite.load_skin("brown")
	
