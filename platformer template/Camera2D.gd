extends Camera2D

func _process(delta):
	offset = lerp(offset, (get_global_mouse_position() - get_parent().position)/17, 0.2)
	#offset = (get_global_mouse_position() - get_parent().position)/17
