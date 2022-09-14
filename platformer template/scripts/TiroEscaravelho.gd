extends RigidBody2D

func _on_LifeTime_timeout():
	queue_free()

func _on_TiroEscaravelho_body_entered(body):
	explode()

func explode():
	print("explode")
	queue_free()
