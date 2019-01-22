extends KinematicBody2D

#Player Variables / Consts
var motion = Vector2()
const JUMP_HEIGHT = -1000
const GRAVITY = 1500
const UP = Vector2(0, -1)

func _ready():
	var skin = Global.data["player"]["model"]
	$Sprite.load_skin(skin)

#Move the player
func _physics_process(delta):
	fall(delta)
	jump()	
	move_and_slide(motion, UP)	

#Makes sure the right animation is playing
func _process(delta):
	$Sprite.update_animation(motion)

func fall(delta):
	if  is_on_floor():
		motion.y = 0
	else:
		motion.y += GRAVITY * delta
	
	motion.y = clamp(motion.y, JUMP_HEIGHT, -JUMP_HEIGHT)


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
	
