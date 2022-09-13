extends Sprite

func _ready():
	visible = false

func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		visible = !visible
		global_position = get_parent().global_player_pos
		get_tree().paused = !get_tree().paused
