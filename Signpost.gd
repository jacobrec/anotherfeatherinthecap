extends Node2D

signal message(text)
export var message := "No message"

func _ready():
	print_debug(self)
	pass

func on_interact(player):
	emit_signal("message", message)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
