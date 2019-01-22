extends AnimatedSprite

var collected = false

func _on_Gold_Area_body_entered(body):
	if not collected: 
		body.collect_coin(10)
		collected = true
		$AudioStreamPlayer.play()
		$AnimationPlayer.play("die")			
		
func _on_Silver_Area_body_entered(body):
	if not collected: 
		body.collect_coin(5)
		collected = true
		$AudioStreamPlayer.play()
		$AnimationPlayer.play("die")
	

func _on_Bronze_Area_body_entered(body):
	if not collected: 
		body.collect_coin(1)
		collected = true
		$AudioStreamPlayer.play()
		$AnimationPlayer.play("die")

func die():
	queue_free()

