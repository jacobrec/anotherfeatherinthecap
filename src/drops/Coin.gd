extends Area2D

export var amount := 1

func _on_CoinDrop_body_entered(body):
	if body.name == "Player":
		State.player.giveGold(amount)
		queue_free()
