extends KinematicBody2D
onready var gravity = get_parent().gravity
onready var player = get_parent().get_node("Player")
onready var area = $Area2D
var velocity = Vector2.ZERO
var exp_value = 15

func _ready():
	$LifeTime.start()

func _physics_process(delta):
	velocity.y += gravity
	move_and_slide(velocity, Vector2(0.0, -1.0))

func _process(delta):
	$AnimatedSprite.modulate.a = $LifeTime.time_left / $LifeTime.wait_time

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.current_life += 1
		body.update_life_sprite()
		queue_free()


func _on_LifeTime_timeout():
	queue_free()
