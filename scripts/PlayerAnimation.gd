extends AnimatedSprite

func update_animation(motion):	
	if get_parent().is_on_floor() and not get_parent().is_on_ceiling():
		if motion.x > 0:
			playAnimation("run", false)
		elif motion.x < 0:
			playAnimation("run", true)
		elif motion.x == 0:
			playAnimation("idle", true)
	else:		
		#Check if hasn't just taken damage, else jump 
		if get_animation() != "hurt": 
			#Bug fixing
			#Motion Y is at always 33 (even at reseting), unless the player is falling or jumping
			if motion.y > 33 or motion.y < 0:
				playAnimation("jump", false)
		

func playAnimation(animation, flip):
	play(animation)
	if flip:
		flip_h = true
	else:
		flip_h = false

#Initialize skin variables
var Idle0 
var Idle1
var hurt 
var jump 
var run0 
var run1
#Load the skin	
func load_skin(model):	
	if model == "brown":		
		Idle0 = preload("res://images/players/bunny1_stand.png")
		Idle1 = preload("res://images/players/bunny1_ready.png")
		hurt = preload("res://images/players/bunny1_hurt.png")
		jump = preload("res://images/players/bunny1_jump.png")
		run0 = preload("res://images/players/bunny1_walk1.png")
		run1 = preload("res://images/players/bunny1_walk2.png")
	else:
		Idle0 = preload("res://images/players/bunny2_stand.png")
		Idle1 = preload("res://images/players/bunny2_ready.png")
		hurt = preload("res://images/players/bunny2_hurt.png")
		jump = preload("res://images/players/bunny2_jump.png")
		run0 = preload("res://images/players/bunny2_walk1.png")
		run1 = preload("res://images/players/bunny2_walk2.png")

	Global.update_data("player", "model", model, "PlayerAnimation.gd")	
	change_skin()
	
#Change the skin after loading them
func change_skin():		
	frames.set_frame("idle", 0, Idle0)
	frames.set_frame("idle", 1, Idle1)
	frames.set_frame("hurt", 0, hurt)
	frames.set_frame("jump", 0, jump)
	frames.set_frame("run", 0, run0)
	frames.set_frame("run", 1, run1)


