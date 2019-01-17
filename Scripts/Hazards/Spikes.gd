extends Area2D

func _on_spikes_body_entered(body):
	body.take_damage()


