extends Control

onready var msgbox = get_node("Messagebox")
onready var msg = msgbox.get_node("Message")

func show_message(text):
	msg.text = text
	msg.lines_skipped = 0

func _ready():
	msg.text = ""
	msg.hide()
	msgbox.hide()

func _process(delta):
	if msg.text != "" and !msg.visible:
		msgbox.show()
		msg.show()
	elif Input.is_action_just_pressed("action3"):
		if msg.text != "":
			msg.lines_skipped += msg.get_visible_line_count()
			if msg.get_line_count() <= msg.lines_skipped:
				msg.text = ""
				msg.hide()
				msgbox.hide()

func _on_Signpost_message(text):
	if msg.text == "":
		show_message(text)

func _on_Player_healthChanged(current, maxhealth):
	print(current, maxhealth)
