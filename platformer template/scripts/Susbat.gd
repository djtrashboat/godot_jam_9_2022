extends KinematicBody2D
onready var sprite = $AnimatedSprite

var vel = Vector2.ZERO

var life = 2
var count = 0

var rand = RandomNumberGenerator.new()

func get_hurt():
	life -= 1
	if (life <= 0):
		queue_free()

func _ready():
	pass # Replace with function body.

func _process(delta):
	sprite.play("default")

func _physics_process(delta):
	vel = -(position - get_parent().global_player_pos)
	vel = vel.normalized() * 100
	move_and_slide(vel, Vector2(0.0, -1.0))

func set_knock(v):
	print("test")
