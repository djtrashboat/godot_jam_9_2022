extends Position2D

func _ready():
	pass 

var rand = RandomNumberGenerator.new()

func _on_SpawnerTimer_timeout():
	#print("spawner timeout")
	#var p = get_parent().global_player_pos
	#var screen = get_viewport().get_visible_rect().size
	#var pos = Vector2(rand.randf_range(p.x - screen.x, p.x + screen.x), rand.randf_range(p.y - 200, p.y - screen.y))
	var pos = Vector2(-300 + 1100*(rand.randi()%2), rand.randf_range(-200,130))
	get_parent().spawn_fantasma(pos)
