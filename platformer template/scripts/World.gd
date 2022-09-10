extends Node2D
var global_player_pos = Vector2.ZERO
const SUSBAT_SCENE = preload("res://scenes/Susbat.tscn")

func _ready():
	pass
	
func _process(delta):
	pass

func spawn_susbat(pos):
	var e = SUSBAT_SCENE.instance()
	e.position = pos
	add_child(e)
