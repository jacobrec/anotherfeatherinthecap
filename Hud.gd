extends Node2D

# TODO: make paging and multiline
var canTextChange = true
func show_message(text):
	$Messagebox.show()
	$Message.text = text
	$Message.lines_skipped = 0
	$Message.show()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Message.hide()
	$Messagebox.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("action3"):
		if $Message.text != "":
			$Message.lines_skipped += $Message.get_visible_line_count()
			if $Message.get_line_count() <= $Message.lines_skipped:
				$Message.text = ""
				$Message.hide()
				$Messagebox.hide()

func _on_Signpost_message(text):
	show_message(text)

func canTextChangeNow():
	if canTextChange:
		text_change_cooldown()
		return true
	return false
func text_change_cooldown():
	canTextChange = false
	yield(get_tree().create_timer(0.3), "timeout")
	canTextChange = true
