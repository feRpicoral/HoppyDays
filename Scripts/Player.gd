extends KinematicBody2D

#TODO
#Separate in multiple scripts
#Player.gd is doing too much for a single script

#Player Variables / Consts
var motion = Vector2()
const JUMP_HEIGHT = -1500
const SPEED = 800
const GRAVITY = 2000
const JUMP_BOOST = 1.5

#Editor Variables
export(float) var bottom_limit = 3000.0
export(float) var left_limit = 0.0
export(float) var top_limit = -1500.0
export(bool) var infiniteTop = true
export(int) var lifeCount = 3
export(bool) var infiniteLifes = false

#Set the spawn point
onready var spawnPoint = self.position

func _ready():
	if infiniteLifes: lifeCount = 0
	#Set the life count globaly
	$Global.lifeCount = lifeCount
	lifeCount = $Global.get("lifeCount")
	$Camera2D/GUI/Banner/Lifes/LifeCount.text = String(lifeCount)	
	
	#If saving coins, get them
	if $Global.saveCoins:
		var actualCoins = $Global.get("actualCoins")
		var savedCoins = $Global.data["player"]["coins"]
		$Global.actualCoins = savedCoins
		$Camera2D/GUI/Banner/Coins/CoinCount.text = str($Global.actualCoins)
	
	#Loads the saved model
	var skin = Global.data["player"]["model"]
	$Sprite.load_skin(skin)
	
	

#Move the player based on the inputs
func _physics_process(delta):
	update_motion(delta)

#Change the state of the player
func update_motion(delta):
	fall(delta)
	run()
	jump()	
	move_and_slide(motion, Vector2(0, -1))

#Makes sure the right animation is playing
func _process(delta):
	update_animation(motion)

#Changes the animation based on the motion
func update_animation(motion):
	$Sprite.update(motion)


func fall(delta):
	if  is_on_floor() or is_on_ceiling():
		#Avoid bug with jump pads and damage
		if $Global.canResetMotionY: motion.y = 0
	else:
		motion.y += GRAVITY * delta
	
	#If the player falls from the map, give damage and respawn or restart
	if position.y >= bottom_limit:
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
	get_tree().change_scene("res://Scenes/UI/GameOver.tscn")

#Needed to avoid bug
func allow_reset_motion_y():
	$Global.canResetMotionY = true

func block_reset_motion_y():
	#Timer to avoid bug
	$Global.canResetMotionY = false
	var timer = Timer.new()
	timer.connect("timeout", self, "allow_reset_motion_y")
	add_child(timer)
	timer.set_one_shot(true)
	timer.set_wait_time(0.1)
	timer.start()
	
#Remove one life. If the player has no lifes left, end the game
func take_damage(deathKind=null):
	block_reset_motion_y()	
	
	if not infiniteLifes:
		var globalLifes = $Global.get("lifeCount")
		if globalLifes == 1:
			end_game()
		else:
			#Play hurt sound 
			$HurtSound.play()
			
			#Play GUI Animation
			$Camera2D/GUI/AnimationPlayer.play("Hurt")
			
			if not $Global.stopGUI:
				#Update the life count
				globalLifes -= 1
				$Global.lifeCount = globalLifes
				$Camera2D/GUI/Banner/Lifes/LifeCount.text = String($Global.lifeCount)
		
	#Jump when take damage
	if deathKind != "fall":
		motion.y = JUMP_HEIGHT
		$Sprite.playAnimation("hurt", false)

#Send player to the start of the map
func respawn():
	self.position = spawnPoint

#Add the coins to the GUI
func collect_coin(num):
	#Play Animation
	$Camera2D/GUI/AnimationPlayer.play("CoinPulse")
	
	if not $Global.stopGUI:
		#Get the coins and add them to the global variable
		var actualCoins =  $Global.get("actualCoins")
		var newValue = actualCoins + num
		$Global.actualCoins = newValue
		
		#Show coins in GUI
		$Camera2D/GUI/Banner/Coins/CoinCount.text = str(newValue)
		
#Add one life
func life_up():
	if not infiniteLifes and not $Global.stopGUI:
		#Edit the number of lifes
		var globalLifes = $Global.get("lifeCount")
		globalLifes += 1
		$Global.lifeCount = globalLifes
		$LifeUpSound.play()
		
		#Play Animation
		$Camera2D/GUI/AnimationPlayer.play("LifePulse")
		
		#Show lifes o GUI
		$Camera2D/GUI/Banner/Lifes/LifeCount.text = String($Global.lifeCount)
