extends Tween

export var property := "offset"
export (NodePath) var noderef = ""
export var distance := 0.5

var node
func _ready():
	init(noderef)

func init(nr):
	node = get_node(nr)
	if node != null:
		swap_tween()

func swap_tween():
	interpolate_property(node, property,
		Vector2(0, -distance), Vector2(0, distance), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	start()
	distance *= -1


func _on_Tween_tween_all_completed():
	swap_tween()
