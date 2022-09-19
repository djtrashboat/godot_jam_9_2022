extends KinematicBody2D

onready var sprite = $Sprite
onready var timer_knock = $TimerKnock
onready var timer_ghost_mode = $TimerGhostMode
onready var hurt_box_body = $HurtBox/CollisionShape2D
var exp_value = 35


enum {
	NORMAL,
	GHOST,
	KNOCK
}

#########
var vel = Vector2.ZERO
var state = NORMAL
var life = 5
var count = 0
var speed = 100

#########
export var ghost_speed = 35
export var normal_speed = 75
#export var timer_range = Vector2(4.0,7.0)

func _ready():
	timer_ghost_mode.start()

func _physics_process(delta):
	vel = -(position - get_parent().global_player_pos)
	vel = vel.normalized() * speed
	move_and_slide(vel, Vector2(0.0, -1.0))

func _process(delta):
	if state != KNOCK:
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
	change_to_knock()

func die():
	var xpdrop = get_parent().XP_DROP_SCENE.instance()
	xpdrop.global_position = global_position
	xpdrop.exp_value = exp_value
	get_parent().call_deferred("add_child", xpdrop)
	queue_free()

func _on_TimerKnock_timeout():
	timer_ghost_mode.set_paused(false)
	change_to_ghost()
	state = GHOST

func _on_TimerGhostMode_timeout():
	change_state()

func change_state():
	match state:
		GHOST:
			state = NORMAL
			change_to_normal()
		NORMAL:
			state = GHOST
			change_to_ghost()

func change_to_ghost():
	#hurt_box.call_deferred("set_disabled", true)
	state = GHOST
	hurt_box_body.set_disabled(true)
	speed = ghost_speed
	sprite.modulate = Color(0,0.5,1,0.5)
	timer_ghost_mode.start()

func change_to_normal():
	state = NORMAL
	hurt_box_body.set_disabled(false)
	speed = normal_speed
	sprite.modulate = Color(1,1,1,0.8)
	timer_ghost_mode.start()

func change_to_knock():
	state = KNOCK
	speed = -speed
	sprite.modulate = Color.red
	#timer_ghost_mode.stop()
	timer_ghost_mode.set_paused(true)
	timer_knock.start()
