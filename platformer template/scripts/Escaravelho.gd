extends StaticBody2D

const TIRO = preload("res://scenes/TiroEscaravelho.tscn")

onready var timer_modulate = $TimerModulate
onready var spawner_de_tiro = $Sprite/TiroSpawn
onready var sprite = $Sprite
var exp_value = 25

export var hp = 4

func _process(delta):
	look_at(get_parent().global_player_pos)

func knockout():
	#queue_free()
	pass

func get_hurt(dmg: int):
	hp-=dmg
	if hp<=0:
		die()
	modulate = Color.salmon
	timer_modulate.start()

func die():
	var xpdrop = get_parent().XP_DROP_SCENE.instance()
	xpdrop.global_position = global_position
	xpdrop.exp_value = exp_value
	get_parent().call_deferred("add_child", xpdrop)
	queue_free()

func _on_TimerModulate_timeout():
	modulate = Color.white

func shoot():
	var _tiro = TIRO.instance()
	_tiro.position = spawner_de_tiro.global_position
	var dir = (get_parent().global_player_pos - _tiro.position).normalized()
	_tiro.set_linear_velocity(dir * 200)
	get_parent().add_child(_tiro)
	sprite.frame = 1
	#yield(get_tree().create_timer(0.08), "timeout")
	sprite.frame = 0


func _on_TimerAttack_timeout():
	shoot()

func _on_REM_ERRORS_timeout():
	sprite.frame = 0


func _on_LifeTime_timeout():
	queue_free()
