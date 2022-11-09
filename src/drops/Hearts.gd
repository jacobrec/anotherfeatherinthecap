extends Area2D

export var healthRestore := 4

func _on_Heart_body_entered(body):
	if body.name == "Player":
		body.damage(-healthRestore)
		queue_free()
