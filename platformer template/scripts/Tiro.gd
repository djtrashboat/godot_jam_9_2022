extends RigidBody2D

export var life = 1

func _on_LifeTime_timeout():
	queue_free()

func _on_Tiro_body_entered(body):
	queue_free()

func take_dmg():
	#print("tiro dmg")
	life -=1
	if life <= 0:
		queue_free()
