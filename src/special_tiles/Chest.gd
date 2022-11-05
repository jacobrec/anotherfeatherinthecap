extends KinematicBody2D

var is_open = false
export (int) var gold := 0

func on_interact(_player):
	if !is_open:
		$AnimatedSprite.play()
		is_open = true

func _on_AnimatedSprite_animation_finished():
	State.set_message("You recieved " + str(gold) + " gold!")
	State.player.giveGold(gold)
