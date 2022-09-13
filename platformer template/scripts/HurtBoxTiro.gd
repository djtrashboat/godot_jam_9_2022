extends Area2D

func _ready():
	pass

func _on_HurtBox_body_entered(body):
	var enemy = get_parent()
	enemy.knockout()
	enemy.get_hurt(body.dmg)
	if body.is_in_group("TIRO"):
		body.take_dmg(1)
