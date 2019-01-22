extends Node2D

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
