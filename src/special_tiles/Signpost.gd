extends Node2D

signal message(text)
export var message := ""

func _ready():
	pass

func on_interact(_player):
	emit_signal("message", message)

func on_sword_hit(_player):
	$Sign.texture = load("res://src/special_tiles/signbreak.tres")
	yield(get_tree().create_timer(1),"timeout")
	queue_free()
