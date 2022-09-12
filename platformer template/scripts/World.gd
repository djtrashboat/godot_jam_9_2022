extends Node2D
var global_player_pos = Vector2.ZERO
const SUSBAT_SCENE = preload("res://scenes/Susbat.tscn")
onready var nav_2d: Navigation2D = $Navigation2D

func _ready():
	pass
	
func _process(delta):
	pass

func spawn_susbat(pos):
	var e = SUSBAT_SCENE.instance()
	e.position = pos
	add_child(e)

func set_global_player_pos(player_pos: Vector2):
	global_player_pos = player_pos
