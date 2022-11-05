extends KinematicBody2D

onready var ani = $AnimatedSprite

export var moveSpeed = 20
export var fieldOfView = 80
var is_dead = false

func _ready():
	pass # Replace with function body.


func _physics_process (_delta): # TODO: Add a leap towards player
	var vel = State.player.position - self.position
	if vel.length() <= fieldOfView and not is_dead:
		vel = vel.normalized()
		var _vec = move_and_slide(vel * moveSpeed, Vector2.ZERO)

func on_collide (player):
	if not is_dead:
		player.damage(1)

func on_sword_hit(_player):
	ani.play("dead")
	is_dead = true
	yield(get_tree().create_timer(0.5),"timeout")
	queue_free()
