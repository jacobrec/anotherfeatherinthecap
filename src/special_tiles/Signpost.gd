extends Node2D

signal message(text)
export var message := ""

func _ready():
	pass

func on_interact(_player):
	emit_signal("message", message)

func on_sword_hit(_player):
	queue_free()
