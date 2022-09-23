extends Position2D

func _ready():
	pass 

var rand = RandomNumberGenerator.new()

func _on_SpawnerTimer_timeout():
#	var p = get_parent().global_player_pos
#	var screen = get_viewport().get_visible_rect().size / 2
#	var pos = Vector2(rand.randf_range(p.x - screen.x, p.x + screen.x), rand.randf_range(p.y - 200, p.y - screen.y))
#	pos.y += 50
	var posx = rand.randf_range(-80,550)
	var pos = Vector2(posx, rand.randf_range(-90 ,45) + posx / 6.5)
	get_parent().spawn_escaravelho(pos)
