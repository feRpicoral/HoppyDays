extends Sprite
onready var posY = self.position.y

func _ready():
	$AnimationPlayer.get_animation("default").loop = true
	$AnimationPlayer.play("default")

#Updates the Y position based on the current position
func update(y):
	self.position.y += y

#Set postion to original pos
func reset():
	self.position.y = posY


func _on_body_entered(body):
	#Play collected animation and remove carrot
	$AnimationPlayer.stop()
	$AnimationPlayer.play("collected")
	
	#Play sound
	body.get_node("LifeUpSound").play()
	
	#Gives one life
	body.life_up()

#Called from animation
func die():
	queue_free()
