extends KinematicBody2D

onready var sprite = $Sprite
onready var timer_knock = $TimerKnock
onready var timer_ghost_mode = $TimerGhostMode
#onready var hurt_box = $hitbox/CollisionShape2D
onready var hurt_box_body = $HurtBox/CollisionShape2D

enum {
	NORMAL,
	GHOST,
	KNOCK
}

#########
var vel = Vector2.ZERO
var state = NORMAL
var life = 2
var count = 0
var speed = 100

#########
export var ghost_speed = 50
export var normal_speed = 100
export var timer_range = Vector2(4.0,7.0)

func _ready():
	timer_ghost_mode.start()

func _physics_process(delta):
	vel = -(position - get_parent().global_player_pos)
	vel = vel.normalized() * speed
	move_and_slide(vel, Vector2(0.0, -1.0))

func _process(delta):
	if vel.x > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

func get_hurt(amount):
	life -= amount
	if (life <= 0):
		die()

func knockout():
	#sprite.modulate = Color.red
	timer_knock.start()

func _on_TimerKnock_timeout():
	#sprite.modulate = Color.white
	#sprite.modulate.a = 0.78
	pass

func die():
	queue_free()

func _on_TimerGhostMode_timeout():
	print("timeout")
	change_state()

func change_state():
	print("state is", state)
#	if GHOST:
#		state = NORMAL
#		change_to_normal()
#	else:
#		state = GHOST
#		change_to_ghost()
	match state:
		GHOST:
			print("state is now", state)
			state = NORMAL
			change_to_normal()
		NORMAL:
			print("state is now", state)
			state = GHOST
			change_to_ghost()

func change_to_ghost():
	print("change_to_ghost")
	#hurt_box.call_deferred("set_disabled", true)
	hurt_box_body.set_disabled(true)
	speed = ghost_speed
	sprite.modulate = Color(0,0.5,1,0.5)
	timer_ghost_mode.start()

func change_to_normal():
	print("change_to_normal")
	#hurt_box.call_deferred("set_disabled", false)
	hurt_box_body.set_disabled(false)
	speed = normal_speed
	sprite.modulate = Color(1,1,1,0.8)
	timer_ghost_mode.start()
