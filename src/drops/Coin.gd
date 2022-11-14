extends Area2D

export var amount := 1


var Shadow = load("res://src/utils/Shadow.gd")
func _ready():
	Shadow.create_shadow($Sprite)

func _on_CoinDrop_body_entered(body):
	if body.name == "Player":
		State.player.giveGold(amount)
		queue_free()
