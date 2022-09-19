extends Node2D
const WORLD = preload("res://scenes/World.tscn")
onready var tween_out = get_node("FadeOut")
onready var tween_in = get_node("FadeIn")
onready var music_db = -30 + Autoload.music_volume

onready var sfx_on_sprite = preload("res://assets/art/sfx_button1.png")
onready var sfx_off_sprite = preload("res://assets/art/sfx_button3.png")
onready var music_on_sprite = preload("res://assets/art/music_button1.png")
onready var music_off_sprite = preload("res://assets/art/music_button3.png")

export var transition_duration = 1
export var transition_type = 1

func fade_out(stream_player):
	tween_out.interpolate_property(stream_player, "volume_db", music_db, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_out.start()

func fade_in(stream_player):
	tween_in.interpolate_property(stream_player, "volume_db", -80, music_db, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_in.start()

func _ready():
	fade_in($AudioStreamPlayer)

func _on_Button_button_down():
	add_child(WORLD.instance())
	fade_out($AudioStreamPlayer)
	$UI.queue_free()
	$PlayButton.queue_free()

func _on_FadeOut_tween_completed(object, key):
	object.stop()
	$AudioStreamPlayer.queue_free()

func _on_FadeIn_tween_started(object, key):
	object.play()


func _on_PLAYButton_button_up():
	add_child(WORLD.instance())
	fade_out($AudioStreamPlayer)
	$UI.queue_free()
	$PLAYButton.queue_free()
	$SFXButton.queue_free()
	$MUSICButton.queue_free()


func _on_SFXButton_button_up():
	if Autoload.sfx_volume == 0:
		Autoload.sfx_volume = -100
		$SFXButton.texture_normal = sfx_off_sprite
	else:
		Autoload.sfx_volume = 0
		$SFXButton.texture_normal = sfx_on_sprite
	

func _on_MUSICButton_button_up():
	if Autoload.music_volume == 0:
		Autoload.music_volume = -100
		$MUSICButton.texture_normal = music_off_sprite
	else:
		Autoload.music_volume = 0
		$MUSICButton.texture_normal = music_on_sprite
	music_db = -30 + Autoload.music_volume
	fade_in($AudioStreamPlayer)
