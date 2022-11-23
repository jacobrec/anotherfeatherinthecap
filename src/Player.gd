extends KinematicBody2D

signal healthChanged(currentHealth, maxHealth)
signal goldChanged(newGold)

var maxHealth = 4 * 3
var hp = 12
var gold = 10
var equipped_1 = Constants.Equipment.Sword
var equipped_2 = Constants.Equipment.Bomb

var moveSpeed : int = 250
var interactDist : int = 12
var vel = Vector2()
var facingDir = Vector2(0, 1)

onready var anim = $AnimatedSprite

var holding = null
var isAttackAnimating = false
var is_shielding = false
var Arrow = load("res://src/Arrow.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("healthChanged", hp, maxHealth)
	State.player = self
	giveGold(0)
	load("res://src/utils/Shadow.gd").create_shadow($AnimatedSprite)


func _process(_delta):
	$SwordArea.rotation = facingDir.angle() - PI/2
	$ShieldArea.rotation = facingDir.angle() - PI/2
	is_shielding = false
	if Input.is_action_just_pressed("action3"):
		var collisions = $SwordArea.get_overlapping_bodies()
		for collided in collisions:
			if collided.has_method("on_interact"):
				collided.on_interact(self)
	elif Input.is_action_just_pressed("action1"):
		action(equipped_1, true)
	elif Input.is_action_pressed("action1"):
		action(equipped_1, false)
	elif Input.is_action_just_pressed("action2"):
		action(equipped_2, true)
	elif Input.is_action_pressed("action2"):
		action(equipped_2, false)

func action(act, just):
	if !isAttackAnimating:
		match [act, just]:
			[Constants.Equipment.Sword, true]:
				var collisions = $SwordArea.get_overlapping_bodies()
				for collided in collisions:
					print_debug(collided)
					if collided.has_method("on_sword_hit"):
						collided.on_sword_hit(self)
				if facingDir.x == 1:
					play_animation("SwordRight", true)
				elif facingDir.x == -1:
					play_animation("SwordLeft", true)
				elif facingDir.y == -1:
					play_animation("SwordUp", true)
				elif facingDir.y == 1:
					play_animation("SwordDown", true)
			[Constants.Equipment.Bow, true]:
				var arrow = Arrow.instance()
				arrow.z_index = z_index + 1
				if facingDir.x == 1:
					play_animation("BowRight", true)
					arrow.direction =  Vector2(1, 0)
				elif facingDir.x == -1:
					play_animation("BowLeft", true)
					arrow.direction =  Vector2(-1, 0)
				elif facingDir.y == -1:
					play_animation("BowUp", true)
					arrow.direction =  Vector2(0, -1)
					arrow.z_index = z_index - 2
				elif facingDir.y == 1:
					play_animation("BowDown", true)
					arrow.direction =  Vector2(0, 1)
				arrow.position = position
				arrow.position.y += 5
				if gold > 0:
					giveGold(-1)
					get_parent().add_child(arrow)
			[Constants.Equipment.Shield, _]:
				is_shielding = true

func _physics_process (_delta):
	vel = Vector2()
	# inputs
	if !isAttackAnimating:
		if Input.is_action_pressed("move_up"):
			vel.y -= 1
			facingDir = Vector2(0, -1)
		if Input.is_action_pressed("move_down"):
			vel.y += 1
			facingDir = Vector2(0, 1)
		if Input.is_action_pressed("move_left"):
			vel.x -= 1
			facingDir = Vector2(-1, 0)
		if Input.is_action_pressed("move_right"):
			vel.x += 1
			facingDir = Vector2(1, 0)
		# normalize the velocity to prevent faster diagonal movement
	vel = vel.normalized()
	# move the player
	# dont update velocity to prevent sliding around rounded obsticals
	var _vel = move_and_slide(vel * moveSpeed, Vector2.ZERO)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.has_method("on_collide"):
			collision.collider.on_collide(self)
	manage_animations()

func play_animation (anim_name, lock=false):
	if lock:
		lock_animation(anim.frames.get_frame_count(anim_name)
			/ anim.frames.get_animation_speed(anim_name))
	if anim.animation != anim_name:
		anim.play(anim_name)

func manage_animations ():
	if isAttackAnimating:
		pass
	elif is_shielding:
		play_walkidletype_animation("Shield")
	elif holding:
		play_walkidletype_animation("Carry")
	else:
		play_walkidletype_animation("")

func play_walkidletype_animation(animation):
	if vel.x != 0 || vel.y != 0:
		play_directional_animation(animation + "Walk")
	else:
		play_directional_animation(animation + "Idle")

func play_directional_animation(animation):
	if facingDir.x == 1:
		play_animation(animation + "Right")
	elif facingDir.x == -1:
		play_animation(animation + "Left")
	elif facingDir.y == -1:
		play_animation(animation + "Up")
	elif facingDir.y == 1:
		play_animation(animation + "Down")


func lock_animation (timedelay):
	isAttackAnimating = true
	yield(get_tree().create_timer(timedelay),"timeout")
	isAttackAnimating = false


var is_damage_immune = false
func damage_shielded (attack, incoming_body):
	if is_shielding and $ShieldArea.overlaps_body(incoming_body):
		return false
	damage(attack)
	return true
func damage (attack):
	if not is_damage_immune:
		lock_damage(0.3)
		hp -= attack
		if hp <= 0:
			get_tree().change_scene("res://src/screens/game_over.tscn")
		if hp > maxHealth:
			hp = maxHealth
		emit_signal("healthChanged", hp, maxHealth)

func lock_damage (timedelay):
	is_damage_immune = true
	yield(get_tree().create_timer(timedelay),"timeout")
	is_damage_immune = false

func giveGold(amount):
	gold += amount
	emit_signal("goldChanged", gold)
