extends KinematicBody2D
onready var gravity = get_parent().gravity
onready var player = get_parent().get_node("Player")
onready var area = $Area2D
var velocity = Vector2.ZERO
var exp_value = 15

func _ready():
	pass

func _physics_process(delta):
	velocity.y += gravity
	move_and_slide(velocity, Vector2(0.0, -1.0))

func _process(delta):
	pass

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.current_xp += exp_value
		queue_free()