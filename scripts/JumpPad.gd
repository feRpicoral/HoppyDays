extends Area2D

func _on_body_entered(body):
	body.block_reset_motion_y()
	
	$AnimatedSprite.play("push")
	$Sound.play()
	$Timer.start()
	body.motion.y = body.JUMP_HEIGHT * body.JUMP_BOOST

func _on_timer_timeout():
	$AnimatedSprite.play("idle")
