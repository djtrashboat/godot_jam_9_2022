extends Node2D
var global_player_pos = Vector2.ZERO
const SUSBAT_SCENE = preload("res://scenes/Susbat.tscn")
const SUSSERBAT_SCENE = preload("res://scenes/Susserbat.tscn")
const ESCARAVELHO_SCENE = preload("res://scenes/Escaravelho.tscn")
const FANTASMA_SCENE = preload("res://scenes/Fantasma.tscn")
const XP_DROP_SCENE = preload("res://scenes/XPDrop.tscn")
const LIFE_DROP_SCENE = preload("res://scenes/LifeDrop.tscn")
const ENDGAME = preload("res://scenes/EndGame.tscn")
onready var tween_out = get_node("FadeOut")
onready var tween_in = get_node("FadeIn")
var gravity = 12
onready var nav_2d: Navigation2D = $LevelNavigation
onready var music_db = -30 + Autoload.music_volume
onready var musicas:Array = [$musica2, $musica3]
var current_music = null
var ended = false
var music_index = 0
onready var score = 0

export var transition_duration = 1
export var transition_type = 1

func fade_out(stream_player):
	tween_out.interpolate_property(stream_player, "volume_db", music_db, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_out.start()

func fade_in(stream_player):
	tween_in.interpolate_property(stream_player, "volume_db", -80, music_db, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_in.start()

func _ready():
	fade_in(musicas[music_index])

func _process(delta):
	pass

func spawn_susbat(pos):
	var e = SUSBAT_SCENE.instance()
	e.position = pos
	add_child(e)

func spawn_susserbat(pos):
	var e = SUSSERBAT_SCENE.instance()
	e.position = pos
	add_child(e)

func spawn_escaravelho(pos):
	var e = ESCARAVELHO_SCENE.instance()
	e.position = pos
	add_child(e)

func spawn_fantasma(pos):
	var e = FANTASMA_SCENE.instance()
	e.position = pos
	add_child(e)

func set_global_player_pos(player_pos: Vector2):
	global_player_pos = player_pos

func EndGame():
	ended = true
	for n in get_children():
		if n.name == "Mouse_Cursor":
			continue
		remove_child(n)
		n.queue_free()
	add_child(ENDGAME.instance())

func _on_FadeOut_tween_completed(object, key):
	object.stop()

func _on_FadeIn_tween_started(object, key):
	object.play()

func _on_musica2_finished():
	music_index += 1
	music_index = music_index % len(musicas)
	print(music_index)
	fade_in(musicas[music_index])

func _on_musica3_finished():
	music_index += 1
	music_index = music_index % len(musicas)
	print(music_index)
	fade_in(musicas[music_index])
