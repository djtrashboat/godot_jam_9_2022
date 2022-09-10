extends KinematicBody2D

const TIRO = preload("res://scenes/Tiro.tscn")
const MAXLIFE = 10

onready var spawner_de_tiro = $braco/TiroSpawner
onready var sprite = $AnimatedSprite#animated sprite do player
onready var atk_cd = $atk_cd#timer de cooldown entre tiros
onready var invincible_cd = $invincible_cd
onready var effect = $braco/effect#efeito de raio quando o player atira

var current_life = 10

var velocity = Vector2.ZERO
var knockedout = false#ativo após o player atirar no ar, ele perde o controle do personagem
var can_shoot = true#ativo quando o player pode atirar: após o cd de cada tiro
var is_recoil = false#ativo após o player atirar no chão, ele perde o controle do personagem por uma fração de segundo e sofre uma aceleração oposta a direção do tiro
var is_invincible = false

export var speed = Vector2(150,330)
export var gravity = 12


func _process(delta):
	animate()
	if is_invincible:
		modulate = Color.green
	else:
		modulate = Color.white
	if current_life <= 0:
		modulate = Color.red
	
	if Input.is_action_pressed("mouse_right") and !knockedout and can_shoot:
		shoot()

func _physics_process(delta):
	calculate_velocity(get_input_direction())
	move_and_slide(velocity, Vector2.UP)
	get_parent().global_player_pos = position

func get_input_direction():
	return Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), -Input.get_action_strength("ui_up"))

func calculate_velocity(direction: Vector2):
	if is_recoil:#logo após atirar, o player não tem controle sobre o player por uma fração de segundo
		pass# a velocidade do player é contrária ao sentido do tiro e é calculada em shooting_recoil()
	elif !is_on_floor():
		if !knockedout:
			velocity.x = lerp(velocity.x, direction.x * speed.x, 0.1)#está no ar e não knocado, tem controle, mas com aceleração em x (lerp com peso baixo)
			if is_on_ceiling() or direction.y >= 0 and velocity.y<=0:
				velocity.y = 0#reseta a velocidade vertical quando o player bate no teto ou solta o botão de pular
		elif is_on_ceiling():
			velocity.y = 0#reseta se o player bater no teto com o player knocado também
		elif is_on_wall():
			velocity.x *= -0.5#se estiver knocado e bater na parede, ele quica (bounce)
		velocity.y += gravity
	elif direction.y < 0:# no chão e pulo apertado
		knockedout = false#ao pousar o player deixa de estar knocado
		$braco/mao.visible = true
		velocity.x = lerp(velocity.x, direction.x * speed.x, 0.6) #linha desnecessária#linha desnecessária
		#as linhas acima só fazem tudo funcionar se o player não soltar o botão de pulo
		#sem elas, buga se o player spamar o pulo sem soltar pq ele n chega a terminar de "pousar"
		velocity.y = direction.y * speed.y #performa o pulo
	else:#no chão
		knockedout = false#ao pousar o player deixa de estar knocado
		$braco/mao.visible = true
		velocity.x = lerp(velocity.x, direction.x * speed.x, 0.6)#player controla o personagem normalmente com aceleração relativamente alta
		velocity.y = gravity #para a velocidade vertical não ficar aumentando enquanto o player está no chão 

#func animate():
#	if knockedout:
#		if global_position.x>get_global_mouse_position().x:
#			sprite.flip_h = false
#		else:
#			sprite.flip_h = true	
#		sprite.play("KO2")
#	elif is_recoil:
#		pass
#	elif !is_on_floor():
#		sprite.play("jump")
#	elif velocity.x>1:
#		sprite.flip_h = false
#		sprite.play("run")
#	elif velocity.x<-1:
#		sprite.flip_h = true
#		sprite.play("run")
#	else:
#		sprite.play("idle")

func animate():###########2******************
	var mouse_pos = get_global_mouse_position()
	if mouse_pos.x<global_position.x:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	if knockedout:
		if global_position.x>get_global_mouse_position().x:
			sprite.flip_h = false
		else:
			sprite.flip_h = true	
		sprite.play("KO2")
	elif !is_on_floor():
		sprite.play("jump")
	elif velocity.x>1 or velocity.x<-1:
		sprite.play("run")
	else:
		sprite.play("idle")

func shoot():
	var mouse_pos = get_global_mouse_position()
	can_shoot = false
	atk_cd.start()
	effect.visible = true
	effect.play("default")
	shooting_recoil(mouse_pos, 50.0)
	#####ACC SHOOTING
	#
#	var _tiro = TIRO
#	_tiro.position = Vector2.ZERO
#	get_parent().add_child(_tiro)
	var _tiro = TIRO.instance()
	_tiro.position = spawner_de_tiro.global_position
	#print((global_position-mouse_pos).normalized())
	_tiro.set_linear_velocity((mouse_pos-global_position).normalized() * 200)
	get_parent().add_child(_tiro)
	
	print("pew pew")
	#
	if !is_on_floor():
		apply_impulse(mouse_pos, 270.0)

func apply_impulse(pos: Vector2, amount: float):
	knockedout = true
	$braco/mao.visible = false
	velocity = 270 * Vector2((global_position - pos).normalized())

func _on_atk_cd_timeout():
	can_shoot = true

func _on_invincible_cd_timeout():
	is_invincible = false

func _on_effect_animation_finished():
	effect.visible = false
#	$braco/mao.visible = false
	effect.stop()

func shooting_recoil(op_direction: Vector2, amount: float):
	if is_on_floor():
		is_recoil = true
#		velocity.x *= 0.5
		velocity.x = amount * (global_position - op_direction).normalized().x
		yield(get_tree().create_timer(0.08), "timeout")
		velocity.x = 0
		is_recoil = false

func get_hurt():
	if not is_invincible:
		invincible_cd.start()
		current_life -= 1
	if current_life <= 0:
		print("rip")
	print("Current life:", current_life)

