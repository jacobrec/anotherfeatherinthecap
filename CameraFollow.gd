extends Camera2D

onready var target = get_node("/root/MainScene/Player")
func _process (_delta):
	position = target.position
