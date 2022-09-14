extends StaticBody2D

const TIRO = preload("res://scenes/TiroEscaravelho.tscn")

onready var timer_modulate = $TimerModulate
onready var spawner_de_tiro = $Sprite/TiroSpawn
onready var sprite = $Sprite

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
	sprite.frame = 1
	yield(get_tree().create_timer(0.08), "timeout")
	sprite.frame = 0


func _on_TimerAttack_timeout():
	print("shoot")
	shoot()
