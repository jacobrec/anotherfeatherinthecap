extends KinematicBody2D


var velocity = Vector2(0, 0)
var acceleration = Vector2(0, 0)
var elevation = 0


var has_shadow = false
var Shadow = load("res://src/utils/Shadow.gd")
func on_player_place():
	Shadow.create_shadow($AnimatedSprite)
	has_shadow = true
	set_collision_layer_bit(7, 1)
	$AnimatedSprite.play("lit")

	yield(get_tree().create_timer(2),"timeout")
	$AnimatedSprite.play("boom")
	has_shadow = false
	var shadow = $AnimatedSprite.get_node("shadow")
	$AnimatedSprite.remove_child(shadow)
	for other in $ExplosionArea.get_overlapping_bodies():
		if other.has_method("on_bomb_explode"):
			other.on_bomb_explode()
	yield(get_tree().create_timer(0.45),"timeout")
	queue_free()


func _physics_process (delta):
	if elevation > 0:
		velocity = move_and_slide(velocity)
		elevation -= 30 * delta
	$AnimatedSprite.offset.y = -elevation
	if has_shadow:
		Shadow.set_elevation($AnimatedSprite, elevation/16)
