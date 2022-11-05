extends Area2D

var warp_ready = true
export (NodePath) var warp_to

func _ready():
	var n = get_node(warp_to)
	if not "position" in n or not "warp_ready" in n:
		print_debug("Invalid node: not warp compatible")

func _on_Warp_body_entered(body):
	if body.name == "Player" and warp_ready:
		var n = get_node(warp_to)
		body.position = n.position
		n.warp_ready = false


func _on_Warp_body_exited(body):
	if body.name == "Player":
		warp_ready = true

