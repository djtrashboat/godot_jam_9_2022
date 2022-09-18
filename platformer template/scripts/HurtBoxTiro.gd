extends Area2D

func _ready():
	pass

func _on_HurtBox_body_entered(body):
	if body.is_in_group("TIRO"):
		var enemy = get_parent()
		enemy.knockout()
		enemy.get_hurt(body.dmg)
		if body.has_method("take_dmg"):
			body.take_dmg(1)
			body.dmg /= 1.5
