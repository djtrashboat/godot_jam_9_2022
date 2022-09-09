extends RigidBody2D


func _on_LifeTime_timeout():
	queue_free()

func _on_Tiro_body_entered(body):
	queue_free()
