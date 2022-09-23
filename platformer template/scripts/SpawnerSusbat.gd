extends Position2D

export var variant = false

func _ready():
	pass 

var rand = RandomNumberGenerator.new()

func _on_SpawnTimer_timeout():
	#var p = get_parent().global_player_pos
	#var screen = get_viewport().get_visible_rect().size
	#var pos = Vector2(rand.randf_range(p.x - screen.x, p.x + screen.x), rand.randf_range(p.y - 200, p.y - screen.y))
	var position = Vector2(global_position.x+rand.randf_range(-350,350), global_position.y)#Vector2(position.y,position.x)
	if !variant:
		get_parent().spawn_susbat(position)
	else:
		get_parent().spawn_susserbat(position)
