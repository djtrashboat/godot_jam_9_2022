extends KinematicBody2D
onready var gravity = get_parent().gravity
onready var player = get_parent().get_node("Player")
onready var area = $Area2D
var velocity = Vector2.ZERO
var exp_value = 15

func _ready():
	$beep.volume_db = Autoload.sfx_volume

func _physics_process(delta):
	velocity.y += gravity
	move_and_slide(velocity, Vector2(0.0, -1.0))

#func _process(delta):
#	$AnimatedSprite.modulate.a = $LifeXP.time_left / $LifeXP.wait_time

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.current_xp += exp_value
		$beep.play()

func _on_beep_finished():
	queue_free()
	
func _on_LifeXP_timeout():
	queue_free()


func _on_ModulateTick_timeout():
	$AnimatedSprite.modulate.a = $LifeXP.time_left / $LifeXP.wait_time
