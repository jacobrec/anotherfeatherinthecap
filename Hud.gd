extends Node2D

var canTextChange = true
func show_message(text):
	if canTextChange:
		$Messagebox.show()
		$Message.text = text
		$Message.show()
		text_change_cooldown()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Message.hide()
	$Messagebox.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("action3"):
		if canTextChange:
			$Message.hide()
			$Messagebox.hide()

func _on_Signpost_message(text):
	show_message(text)

func text_change_cooldown():
	canTextChange = false
	yield(get_tree().create_timer(0.1), "timeout")
	canTextChange = true
