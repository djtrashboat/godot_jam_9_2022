extends StaticBody2D

#	var _tiro = TIRO.instance()
#
#		_tiro.life = shoot_pierce_level + 1
#		_tiro.dmg = shoot_dmg_level
#
#		_tiro.position = spawner_de_tiro.global_position
#		var dir = (mouse_pos - _tiro.position).normalized().rotated(-k_fov_shoot / 2 + i * dtheta_front)
#		_tiro.set_linear_velocity(dir * 200)
#		get_parent().add_child(_tiro)

const TIRO = preload("res://scenes/TiroEscaravelho.tscn")

onready var timer_modulate = $TimerModulate
onready var spawner_de_tiro = $Sprite/TiroSpawn

export var hp = 4

func _process(delta):
	look_at(get_parent().global_player_pos)

func knockout():
	pass

func get_hurt(dmg: int):
	hp-=dmg
	if hp<=0:
		die()
	modulate = Color.salmon
	timer_modulate.start()

func die():
	queue_free()

func _on_TimerModulate_timeout():
	modulate = Color.white

func shoot():
	var _tiro = TIRO.instance()
	_tiro.position = spawner_de_tiro.global_position
	var dir = (get_parent().global_player_pos - _tiro.position).normalized()
	_tiro.set_linear_velocity(dir * 200)
	print(dir)
	get_parent().add_child(_tiro)


func _on_TimerAttack_timeout():
	print("shoot")
	shoot()
