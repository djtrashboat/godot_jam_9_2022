extends Area2D

func _ready():
	pass

func _on_HurtBox_body_entered(body):
	var enemy = get_parent()
	enemy.get_hurt(body.dmg)
	enemy.knockout()
	if body.is_in_group("TIRO"):
		body.take_dmg(1)
