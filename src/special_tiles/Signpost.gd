extends Node2D

signal message(text)
export var message := ""

func _ready():
	pass

func on_interact(player):
	emit_signal("message", message)

func on_sword_hit(player):
	queue_free()
