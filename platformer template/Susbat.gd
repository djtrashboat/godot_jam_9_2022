extends KinematicBody2D
onready var sprite = $AnimatedSprite
var vel = Vector2.ZERO
func _ready():
	pass # Replace with function body.

func _process(delta):
	sprite.play("default")

func _physics_process(delta):
	vel = -(position - get_parent().global_player_pos)
	vel = vel.normalized() * 100
	print(vel)
	move_and_slide(vel, Vector2(0.0, -1.0))
