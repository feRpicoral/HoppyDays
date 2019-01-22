extends KinematicBody2D

#Consts
const JUMP_HEIGHT = -1500
const SPEED = 800
const GRAVITY = 2000
const UP = Vector2(0,-1)
const JUMP_BOOST = 1.5

#Editor Variables
export(int) var lives = 3
export(bool) var infinite_lives = false

#Set the spawn point
onready var spawnPoint = self.position

#Variables
var motion = Vector2()
var can_reset_motion_y = true
var coins = 0

func _ready():
	Global.player = self
	if infinite_lives: lives = 0
	
	$Camera2D/GUI/Banner/Lifes/LifeCount.text = String(lives)	
	
	#If saving coins, get them
	if Global.save_coins:
		coins = Global.data["player"]["coins"]
		$Camera2D/GUI/Banner/Coins/CoinCount.text = str(coins)
	
	#Loads the saved model
	var skin = Global.data["player"]["model"]
	$Sprite.load_skin(skin)

#Move the player based on the inputs
func _physics_process(delta):
	fall(delta)
	run()
	jump()	
	move_and_slide(motion, UP)
	

#Makes sure the right animation is playing
func _process(delta):
	$Sprite.update_animation(motion)

func fall(delta):
	if  is_on_floor() or is_on_ceiling():
		#Avoid bug with jump pads and damage
		if can_reset_motion_y: motion.y = 0
	else:
		motion.y += GRAVITY * delta
	
	#If the player falls from the map, give damage and respawn or restart
	if position.y >= Global.bottom_limit:
		take_damage("fall")
		respawn()
	
	motion.y = clamp(motion.y, (JUMP_HEIGHT * JUMP_BOOST), -JUMP_HEIGHT)

	
func run():	
	if not is_on_ceiling():
		if Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
			motion.x = SPEED			
		elif Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
			motion.x = -SPEED
		else:
			motion.x = 0
	else:
		motion.x = 0

func jump():
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
			$JumpSound.play()

#Ends the game		
func end_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene(Global.game_over)

#Needed to avoid bug
func allow_reset_motion_y():
	can_reset_motion_y = true

func block_reset_motion_y():
	can_reset_motion_y = false
	
	#Timer to avoid bug
	var timer = Timer.new()
	timer.connect("timeout", self, "allow_reset_motion_y")
	add_child(timer)
	timer.set_one_shot(true)
	timer.set_wait_time(0.1)
	timer.start()
	
func take_damage(death_reason=null):
	block_reset_motion_y()	
	
	if not infinite_lives:
		if lives == 1:
			end_game()
		else:
			#Play hurt sound 
			$HurtSound.play()
			
			#Play GUI Animation
			$Camera2D/GUI/AnimationPlayer.play("Hurt")
			
			if not Global.stop_gui:
				lives -= 1
				$Camera2D/GUI/Banner/Lifes/LifeCount.text = str(lives)
		
	#Jump when take damage
	if death_reason != "fall":
		motion.y = JUMP_HEIGHT
		$Sprite.playAnimation("hurt", false)

#Send player to the start of the map
func respawn():
	self.position = spawnPoint

#Add the coins to the GUI
func collect_coin(num):
	#Play Animation
	$Camera2D/GUI/AnimationPlayer.play("CoinPulse")
	
	if not Global.stop_gui:
		coins += num
		
		#Show coins in GUI
		$Camera2D/GUI/Banner/Coins/CoinCount.text = str(coins)
		
#Add one life
func life_up():
	if not infinite_lives and not Global.stop_gui:
		lives += 1
		$LifeUpSound.play()
		
		#Play Animation
		$Camera2D/GUI/AnimationPlayer.play("LifePulse")
		
		#Show lifes o GUI
		$Camera2D/GUI/Banner/Lifes/LifeCount.text = str(lives)
