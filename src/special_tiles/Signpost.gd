extends Node2D

export var message := ""
var isbroke = false

func _ready():
	pass

func on_interact(_player):
	if !isbroke:
		State.set_message(message)

func perform_break():
	$Sign.texture = load("res://src/special_tiles/signbreak.tres")
	isbroke = true
	$Sign.texture.current_frame = 0
	yield(get_tree().create_timer($Sign.texture.frames / $Sign.texture.fps),"timeout")
	queue_free()
func on_sword_hit(_player):
	perform_break()

func on_bomb_explode():
	queue_free()
