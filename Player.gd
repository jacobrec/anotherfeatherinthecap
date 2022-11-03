extends KinematicBody2D

signal healthChanged(currentHealth, maxHealth)
var maxHealth = 4 * 3
var hp = 12

var moveSpeed : int = 250
var interactDist : int = 10
var vel = Vector2()
var facingDir = Vector2(0, 1)

onready var rayCast = $RayCast2D
onready var anim = $AnimatedSprite

var isAttackAnimating = false

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("healthChanged", hp, maxHealth)


func _process(delta):
	rayCast.cast_to = facingDir * interactDist
	$Line2D.set_point_position(1, facingDir * interactDist)
	if Input.is_action_just_pressed("action3"):
		if rayCast.is_colliding():
			if rayCast.get_collider().has_method("on_interact"):
				rayCast.get_collider().on_interact(self)
	if Input.is_action_just_pressed("action1"):
		if rayCast.is_colliding():
			if rayCast.get_collider().has_method("on_sword_hit"):
				rayCast.get_collider().on_sword_hit(self)
		isAttackAnimating = true
		unlock_animation(0.25)
		if facingDir.x == 1:
			play_animation("SwordRight")
		elif facingDir.x == -1:
			play_animation("SwordLeft")
		elif facingDir.y == -1:
			play_animation("SwordUp")
		elif facingDir.y == 1:
			play_animation("SwordDown")

func _physics_process (delta):
	vel = Vector2()
	# inputs
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
	move_and_slide(vel * moveSpeed, Vector2.ZERO)
	manage_animations()

func play_animation (anim_name):
	if anim.animation != anim_name:
		anim.play(anim_name)
func manage_animations ():
	if isAttackAnimating:
		pass
	elif vel.x > 0:
		play_animation("WalkRight")
	elif vel.x < 0:
		play_animation("WalkLeft")
	elif vel.y < 0:
		play_animation("WalkUp")
	elif vel.y > 0:
		play_animation("WalkDown")
	elif facingDir.x == 1:
		play_animation("IdleRight")
	elif facingDir.x == -1:
		play_animation("IdleLeft")
	elif facingDir.y == -1:
		play_animation("IdleUp")
	elif facingDir.y == 1:
		play_animation("IdleDown")

func unlock_animation (timedelay):
	yield(get_tree().create_timer(timedelay),"timeout")
	isAttackAnimating = false
