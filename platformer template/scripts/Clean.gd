extends Node2D
const WORLD = preload("res://scenes/World.tscn")
onready var tween_out = get_node("FadeOut")
onready var tween_in = get_node("FadeIn")

export var transition_duration = 1
export var transition_type = 1

func fade_out(stream_player):
	tween_out.interpolate_property(stream_player, "volume_db", -10, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_out.start()

func fade_in(stream_player):
	tween_in.interpolate_property(stream_player, "volume_db", -80, -10, transition_duration, transition_type, Tween.EASE_IN, 0)
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
