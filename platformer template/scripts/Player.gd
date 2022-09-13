extends KinematicBody2D

const TIRO = preload("res://scenes/Tiro.tscn")
const MAXLIFE = 10

onready var spawner_de_tiro = $braco/TiroSpawner
onready var sprite = $AnimatedSprite#animated sprite do player
onready var atk_cd = $atk_cd#timer de cooldown entre tiros
onready var invincible_cd = $invincible_cd
onready var effect = $braco/effect#efeito de raio quando o player atira
onready var mao = $braco/mao
onready var aura_col = $Aura/CollisionShape2D
onready var aura_area = $Aura
onready var upgrades_ui = $Upgrades

#upgrades-----------------------------
var upgrades_scene = false

var current_xp = 0
var xp_next_level = 100

var max_aura_level = 5 
var aura_level = 0
var aura_can_hurt = true

var aura_radius = 0
var aura_radius_base = 4

var aura_dps = 0
var aura_dps_base = 1
var aura_ticks_per_sec_base = 10
var aura_timer_time = 1.0 / aura_ticks_per_sec_base


var max_fire_rate_level = 5
var fire_rate_level = 1
onready var atk_cd_base = atk_cd.wait_time


var max_shoot_front_level = 5
var shoot_front_level = 1
var dtheta_front = 0

var max_shoot_back_level = 5
var shoot_back_level = 0
var dtheta_back = 0

var k_fov_shoot = PI / 4

var max_shoot_pierce_level = 5
var shoot_pierce_level = 0

var max_shoot_dmg_level = 5
var shoot_dmg_level = 1
#upgrades-----------------------------

var current_life = 10

var velocity = Vector2.ZERO
var knockedout = false#ativo após o player atirar no ar, ele perde o controle do personagem
var can_shoot = true#ativo quando o player pode atirar: após o cd de cada tiro
var is_recoil = false#ativo após o player atirar no chão, ele perde o controle do personagem por uma fração de segundo e sofre uma aceleração oposta a direção do tiro
var is_invincible = false

export var speed = Vector2(150,330)
export var gravity = 12

func _ready():
	upgrades_ui.visible = false
	
	update_fire_rate_level(0)
	update_shoot_pierce_level(0)
	update_shoot_dmg_level(0)
	update_shoot_back_level(0)
	update_shoot_front_level(0)
	update_aura_level(0)
	print_player_status()

func _process(delta):
	animate()
	if is_invincible:
		modulate.a = 0.4
	else:
		modulate.a = 1.0
		modulate = Color.white
	if current_life <= 0:
		modulate = Color.red
	
	if Input.is_action_pressed("mouse_right") and !knockedout and can_shoot:
		shoot()
		
	if aura_can_hurt:
		aura_hurt(aura_dps * aura_timer_time)
	
	update_levels()

func _physics_process(delta):
	calculate_velocity(get_input_direction())
	move_and_slide(velocity, Vector2.UP)
	get_parent().set_global_player_pos(global_position)

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
		mao.visible = true
		velocity.x = lerp(velocity.x, direction.x * speed.x, 0.6) #linha desnecessária#linha desnecessária
		#as linhas acima só fazem tudo funcionar se o player não soltar o botão de pulo
		#sem elas, buga se o player spamar o pulo sem soltar pq ele n chega a terminar de "pousar"
		velocity.y = direction.y * speed.y #performa o pulo
	else:#no chão
		knockedout = false#ao pousar o player deixa de estar knocado
		mao.visible = true
		velocity.x = lerp(velocity.x, direction.x * speed.x, 0.6)#player controla o personagem normalmente com aceleração relativamente alta
		velocity.y = gravity #para a velocidade vertical não ficar aumentando enquanto o player está no chão 

func _draw():
	draw_circle_arc(Vector2.ZERO, aura_radius, 0, 360, Color(0.0, 0.0, 1.0, 1.0))

func animate():
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
	shooting_recoil(mouse_pos, 50.0 * sign(shoot_front_level - shoot_back_level))
	
	for i in range(1, shoot_front_level + 1):
		var _tiro = TIRO.instance()
		
		_tiro.life = shoot_pierce_level + 1
		_tiro.dmg = shoot_dmg_level
		
		_tiro.position = spawner_de_tiro.global_position
		var dir = (mouse_pos - _tiro.position).normalized().rotated(-k_fov_shoot / 2 + i * dtheta_front)
		_tiro.set_linear_velocity(dir * 200)
		get_parent().add_child(_tiro)
	
	for i in range(1, shoot_back_level + 1):
		var _tiro = TIRO.instance()
		
		_tiro.life = shoot_pierce_level + 1
		_tiro.dmg = shoot_dmg_level
		
		_tiro.position = spawner_de_tiro.global_position
		var dir = -(mouse_pos - _tiro.position).normalized().rotated(k_fov_shoot / 2 - i * dtheta_back)
		_tiro.set_linear_velocity(dir * 200)
		get_parent().add_child(_tiro)

	if !is_on_floor():
		apply_impulse(mouse_pos, 270.0 * sign(shoot_front_level - shoot_back_level))

func apply_impulse(pos: Vector2, amount: float):
	knockedout = true
	mao.visible = false
	velocity = amount * Vector2((global_position - pos).normalized())

func _on_atk_cd_timeout():
	can_shoot = true

func _on_invincible_cd_timeout():
	is_invincible = false

func _on_effect_animation_finished():
	effect.visible = false
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

func update_fire_rate_level(increment):
	fire_rate_level = clamp(fire_rate_level + increment, 1, max_fire_rate_level)
	atk_cd.wait_time = atk_cd_base / (fire_rate_level * 1.1)

func update_shoot_pierce_level(increment):
	shoot_pierce_level = clamp(shoot_pierce_level + increment, 0, max_shoot_pierce_level)
	
func update_shoot_dmg_level(increment):
	shoot_dmg_level = clamp(shoot_dmg_level + increment, 1, max_shoot_dmg_level)

func update_shoot_front_level(increment):
	shoot_front_level = clamp(shoot_front_level + increment, 1, max_shoot_front_level)
	dtheta_front = k_fov_shoot / (shoot_front_level + 1)

func update_shoot_back_level(increment):
	shoot_back_level = clamp(shoot_back_level + increment, 0, max_shoot_back_level)
	dtheta_back = k_fov_shoot / (shoot_back_level + 1)

func update_aura_level(increment):
	aura_level = clamp(aura_level + increment, 0, max_aura_level)
	aura_radius = aura_radius_base * aura_level * 5;
	aura_dps = aura_dps_base * aura_level * 1.5
	aura_col.shape.radius = aura_radius
	$aura_tick.wait_time = aura_timer_time

#https://docs.godotengine.org/en/stable/tutorials/2d/custom_drawing_in_2d.html
func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)

func _on_aura_tick_timeout():
	aura_can_hurt = aura_level > 0

func aura_hurt(dmg):
	aura_can_hurt = false
	var bodies = aura_area.get_overlapping_bodies()
	for i in range(0, len(bodies)):
		bodies[i].get_hurt(dmg)

func update_levels():
	if current_xp >= xp_next_level:
		current_xp = current_xp - xp_next_level
		upgrades_ui.global_position = global_position - get_parent().get_viewport_rect().size / 4
		upgrades_ui.visible = true
		upgrades_ui.modulate.a = 1.0
		upgrades_scene = true
		get_tree().paused = true

func _on_Aura_button_down():
	if upgrades_scene:
		update_aura_level(1)
		update()
		print_player_status()
	upgrades_ui.visible = false
	upgrades_scene = false
	get_tree().paused = false

func _on_DMG_button_down():
	if upgrades_scene:
		update_shoot_dmg_level(1)
		print_player_status()
	upgrades_ui.visible = false
	upgrades_scene = false
	get_tree().paused = false

func _on_Pierce_button_down():
	if upgrades_scene:
		update_shoot_pierce_level(1)
		print_player_status()
	upgrades_ui.visible = false
	upgrades_scene = false
	get_tree().paused = false

func _on_FireRate_button_down():
	if upgrades_scene:
		update_fire_rate_level(1)
		print_player_status()
	upgrades_ui.visible = false
	upgrades_scene = false
	get_tree().paused = false

func _on_Front_button_down():
	if upgrades_scene:
		update_shoot_front_level(1)
		print_player_status()
	upgrades_ui.visible = false
	upgrades_scene = false
	get_tree().paused = false

func _on_Back_button_down():
	if upgrades_scene:
		update_shoot_back_level(1)
		print_player_status()
	upgrades_ui.visible = false
	upgrades_scene = false
	get_tree().paused = false

func print_player_status():
	print("-----------------------------------------------------")
	print("Player Status: ")
	print("Aura Level: ", aura_level, " Aura Radius: ", aura_radius, " Aura DPS: ", aura_dps, " Aura Frequency: ", aura_ticks_per_sec_base)
	print("Fire Rate Level: ", fire_rate_level)
	print("Shoot Front Level: ", shoot_front_level)
	print("Shoot Back Level: ", shoot_back_level)
	print("Shoot Pierce Level: ", shoot_pierce_level)
	print("Shoot DMG: ", shoot_dmg_level)
	print("Current Life: ", current_life)
	print("Current XP: ", current_xp)
	print("XP to Next Level: ", xp_next_level)
	print("-----------------------------------------------------")
