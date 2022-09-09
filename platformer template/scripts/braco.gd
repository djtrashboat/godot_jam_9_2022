extends Position2D

onready var mao = $mao
#onready var effect = $mao/effect

func _ready():
	pass # Replace with function body.

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	if mouse_pos.x>global_position.x:
		mao.flip_v = false
		look_at(mouse_pos)
	else:
		mao.flip_v = true
		look_at(Vector2(mouse_pos.x, mouse_pos.y))
