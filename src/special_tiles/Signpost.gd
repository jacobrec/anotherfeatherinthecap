extends Node2D

signal message(text)
export var message := ""

func _ready():
	pass

func on_interact(player): # TODO: this seems a little unreliable
	emit_signal("message", message)
