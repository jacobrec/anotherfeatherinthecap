extends Control

onready var msgbox = $Textpane.get_node("Messagebox")
onready var msg = msgbox.get_node("Message")

func show_message(text):
	msg.text = text

func _on_Player_goldChanged(newGold):
	$Coins.get_node("Label").text = str(newGold)
	
func _ready():
	# msg.text = ""
	State.textbox = msg
	msg.hide()
	msgbox.hide()
	pause_mode = Node.PAUSE_MODE_PROCESS


func _process(_delta):
	if msg.text != "" and !msg.visible:
		msgbox.show()
		msg.show()
		get_tree().paused = true
	elif Input.is_action_just_pressed("action3"):
		if msg.text != "":
			msg.lines_skipped += msg.get_visible_line_count()
			if msg.get_line_count() <= msg.lines_skipped:
				msg.text = ""
				msg.hide()
				msgbox.hide()
				get_tree().paused = false
				msg.lines_skipped = 0

func _on_Signpost_message(text):
	if msg.text == "":
		show_message(text)

func _on_Player_healthChanged(current, maxhealth):
	delete_children($HeartBox)

	var heart = Sprite.new()
	heart.texture = load("res://gfx/Tiny Adventure Pack/Other/Heart.png")
	heart.scale = Vector2(3, 3)
	var scaledHeartSize = heart.texture.get_width() * heart.scale.x / 2 + 1
	var heartCount = 0
	for i in range(0, current/4):
		heart.position = Vector2(
			scaledHeartSize + i * 2 * scaledHeartSize,
			scaledHeartSize
			)
		heartCount += 1
		$HeartBox.add_child(heart.duplicate())

	var partial = current % 4
	if partial:
		if partial == 1:
			heart.texture = load("res://gfx/Tiny Adventure Pack/Other/HeartQuarter.png")
		elif partial == 2:
			heart.texture = load("res://gfx/Tiny Adventure Pack/Other/HeartHalf.png")
		elif partial == 3:
			heart.texture = load("res://gfx/Tiny Adventure Pack/Other/Heart3Quarter.png")
		heart.position = Vector2(
			scaledHeartSize + heartCount * 2 * scaledHeartSize,
			scaledHeartSize
			)
		$HeartBox.add_child(heart.duplicate())
		heartCount += 1

	heart.texture = load("res://gfx/Tiny Adventure Pack/Other/HeartEmpty.png")
	for i in range(heartCount, maxhealth/4):
		heart.position = Vector2(
			scaledHeartSize + i * 2 * scaledHeartSize,
			scaledHeartSize
			)
		heartCount += 1
		$HeartBox.add_child(heart.duplicate())

static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()



func _on_SwordButton_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		equip(Constants.Equipment.Sword, event)
func _on_ShieldButton_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		equip(Constants.Equipment.Shield, event)
func _on_BoomerangButton_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		equip(Constants.Equipment.Boomarang, event)
func _on_BowButton_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		equip(Constants.Equipment.Bow, event)
func _on_BombButton_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		equip(Constants.Equipment.Bomb, event)

onready var frames = [
	null,
	$ItemSelect.get_node("SwordButton").get_node("EquipmentFrame"),
	$ItemSelect.get_node("ShieldButton").get_node("EquipmentFrame"),
	$ItemSelect.get_node("BowButton").get_node("EquipmentFrame"),
	$ItemSelect.get_node("BoomerangButton").get_node("EquipmentFrame"),
	$ItemSelect.get_node("BombButton").get_node("EquipmentFrame"),
]

func equip(item, event):
	if event.button_index == BUTTON_LEFT:
		frames[State.player.equipped_1].play("item")
		State.player.equipped_1 = item
		frames[item].play("item1")
	elif event.button_index == BUTTON_RIGHT:
		frames[State.player.equipped_2].play("item")
		State.player.equipped_2 = item
		frames[item].play("item2")
