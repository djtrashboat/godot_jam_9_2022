extends RigidBody2D

func _on_LifeTime_timeout():
	queue_free()

func _on_TiroEscaravelho_body_entered(body):
	explode()

func explode():
	sleeping = true
	$AnimatedSprite.play("explode")
	$hitbox/CollisionShape2D.call_deferred("set_disabled", false)

func _on_AnimatedSprite_animation_finished():
	queue_free()
