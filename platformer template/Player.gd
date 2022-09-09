extends KinematicBody2D

onready var sprite = $AnimatedSprite
onready var atk_cd = $atk_cd
onready var effect = $braco/effect

var velocity = Vector2.ZERO
var knockedout = false
var can_shoot = true

export var speed = Vector2(150,330)
export var gravity = 12


func _process(delta):
	animate()
	if Input.is_action_pressed("mouse_right") and !knockedout and can_shoot:
		shoot()

func _physics_process(delta):
	calculate_velocity(get_input_direction())
	move_and_slide(velocity, Vector2.UP)

func get_input_direction():
	return Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), -Input.get_action_strength("ui_up"))

func calculate_velocity(direction: Vector2):
	if !is_on_floor():
		if !knockedout:
			velocity.x = lerp(velocity.x, direction.x * speed.x, 0.1)
			if is_on_ceiling() or direction.y >= 0 and velocity.y<=0:
				velocity.y = 0
		elif is_on_ceiling():
			velocity.y = 0
		velocity.y += gravity
	elif direction.y < 0:
		knockedout = false
		$braco/mao.visible = true
		velocity.x = lerp(velocity.x, direction.x * speed.x, 0.6)
		velocity.y = direction.y * speed.y
	else:
		knockedout = false
		$braco/mao.visible = true
		velocity.x = lerp(velocity.x, direction.x * speed.x, 0.6)
		velocity.y = gravity

func animate():
	if knockedout:
		if global_position.x>get_global_mouse_position().x:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
		
		sprite.play("KO2")
	elif !is_on_floor():
		sprite.play("jump")
	elif velocity.x>1:
		sprite.flip_h = false
		sprite.play("run")
	elif velocity.x<-1:
		sprite.flip_h = true
		sprite.play("run")
	else:
		sprite.play("idle")

func shoot():
	var mouse_pos = get_global_mouse_position()
	can_shoot = false
	atk_cd.start()
	effect.visible = true
	effect.play("default")
	#####ACC SHOOTING
	#
	print("pew pew")
	#
	if !is_on_floor():
		apply_impulse(mouse_pos)

func apply_impulse(mouse_pos: Vector2):
	knockedout = true
	$braco/mao.visible = false
	velocity = 270 * Vector2((global_position - mouse_pos).normalized())

func _on_atk_cd_timeout():
	can_shoot = true

func _on_effect_animation_finished():
	effect.visible = false
#	$braco/mao.visible = false
	effect.stop()
