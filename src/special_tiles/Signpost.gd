extends Node2D

signal message(text)
export var message := ""
var isbroke = false

func _ready():
	pass

func on_interact(_player):
	if !isbroke:
		emit_signal("message", message)

func on_sword_hit(_player):
	$Sign.texture = load("res://src/special_tiles/signbreak.tres")
	isbroke = true
	$Sign.texture.current_frame = 0
	yield(get_tree().create_timer($Sign.texture.frames / $Sign.texture.fps),"timeout")
	queue_free()
