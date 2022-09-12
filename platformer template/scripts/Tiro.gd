extends RigidBody2D

export var life = 1
export var dmg = 1

func _on_LifeTime_timeout():
	queue_free()

func _on_Tiro_body_entered(body):
	queue_free()

func take_dmg(amount):
	#print("tiro dmg")
	life -= amount
	if life <= 0:
		queue_free()
