extends KinematicBody2D


var velocity = Vector2(0,0)
var returning = false
var boomspeed = 200
var rotspeed = 30

func _ready():
	velocity = velocity.normalized() * boomspeed

func _process (delta):
	rotation += delta * rotspeed

func _physics_process (delta):
	if returning:
		var vel = State.player.position - self.position
		vel = vel.normalized() * boomspeed
		var v2 = move_and_slide(vel)
		if (State.player.position - self.position).length() < 5:
			queue_free()
	else:
		var v2 = move_and_slide(velocity)
		if v2 != velocity:
			initiate_return()

func initiate_return():
	if not returning:
		returning = true
		collision_mask = 0
		collision_layer = 0
