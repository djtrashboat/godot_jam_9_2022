extends Area2D

func _ready():
	pass

func _on_HurtBox_body_entered(body):
	get_parent().get_hurt()
	if body.name == "Tiro":
		body.queue_free()
