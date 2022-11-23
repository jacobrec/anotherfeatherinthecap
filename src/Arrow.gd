extends Area2D


export var moveSpeed = 200
export var direction = Vector2(1,0)

func _physics_process (delta):
	direction = direction.normalized()
	position += direction * moveSpeed * delta
	rotation = direction.angle()

func _on_Arrow_body_entered(body):
	if body.has_method("on_arrow_hit"):
		body.on_arrow_hit()
	queue_free()
