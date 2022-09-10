extends Area2D

func _ready():
	pass

func _on_HurtBoxPlayer_body_entered(body):
	if not get_parent().is_on_floor():
		get_parent().apply_impulse(body.position, 200)
	else:
		get_parent().shooting_recoil(body.position, 200)
	get_parent().get_hurt()
	if not get_parent().is_invincible:
		get_parent().is_invincible = true
