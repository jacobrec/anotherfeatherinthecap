extends KinematicBody2D

func on_bomb_explode():
	if $Leaves.visible:
		$Leaves.visible = false
	else:
		queue_free()
