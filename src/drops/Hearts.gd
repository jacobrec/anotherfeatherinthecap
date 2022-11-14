extends Area2D

export var healthRestore := 4

func _ready():
	load("res://src/utils/Shadow.gd").create_shadow($Sprite)



func _on_Heart_body_entered(body):
	if body.name == "Player":
		State.player.damage(-healthRestore)
		queue_free()

