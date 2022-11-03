extends KinematicBody2D

var maxHealth = 12
var hp = 12

var moveSpeed : int = 250
var interactDist : int = 20
var vel = Vector2()
var facingDir = Vector2()

onready var rayCast = $RayCast2D
onready var anim = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_just_pressed("action3"):
		try_interact()

func try_interact():
	rayCast.cast_to = facingDir * interactDist
	print_debug("Trying to interact")
	if rayCast.is_colliding():
		print_debug("Hit Something")
		print_debug(rayCast.get_collider())
		if rayCast.get_collider().has_method("on_interact"):
			print_debug("And it was interactable")
			rayCast.get_collider().on_interact(self)

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
	if vel.x > 0:
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
