extends KinematicBody2D

export var moveSpeed = 20
export var fieldOfView = 80
var is_dead = false
var elevation = 0

var Shadow = load("res://src/utils/Shadow.gd")
func _ready():
	Shadow.create_shadow($AnimatedSprite)


func _physics_process (_delta): # TODO: Add a leap towards player
	var vel = State.player.position - self.position
	if vel.length() <= fieldOfView and not is_dead:
		vel = vel.normalized()
		var _vec = move_and_slide(vel * moveSpeed, Vector2.ZERO)

func _process(_delta):
	if not is_dead:
		Shadow.set_elevation($AnimatedSprite, elevation)

func on_collide (player):
	if not is_dead:
		if player.damage_shielded(1, self):
			pass
		else: # Played shielded, bounce back
			pass # TODO: use same leap as attack

func on_sword_hit(_player):
	if not is_dead:
		$AnimatedSprite.play("dead")
		is_dead = true
		yield(get_tree().create_timer(1),"timeout")
		queue_free()
