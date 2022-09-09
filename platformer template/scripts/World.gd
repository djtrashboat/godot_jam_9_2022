extends Node2D
var global_player_pos = Vector2.ZERO
var susbat_scene = load("res://scenes/Susbat.tscn")

func _ready():
	pass
	
func _process(delta):
	pass

func spawn_susbat(pos):
	var e = susbat_scene.instance()
	e.position = pos
	add_child(e)
