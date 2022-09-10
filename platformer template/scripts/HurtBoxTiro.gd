extends Area2D

func _ready():
	pass

func _on_HurtBox_body_entered(body):
	get_parent().get_hurt()
	if body.is_in_group("TIRO"):
		body.take_dmg()
