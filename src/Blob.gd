extends KinematicBody2D

onready var ani = $AnimatedSprite
var is_dead = false
func _ready():
	pass # Replace with function body.


#func _process(delta):
#	pass

func on_collide (player):
	if not is_dead:
		player.damage(1)

func on_sword_hit(_player):
	ani.play("dead")
	is_dead = true
	yield(get_tree().create_timer(0.5),"timeout")
	queue_free()
