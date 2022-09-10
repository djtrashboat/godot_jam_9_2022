extends Area2D

func _ready():
	pass

func _on_HurtBoxPlayer_body_entered(body):
	get_parent().shooting_recoil(body.position, 270)
	get_parent().get_hurt()
	if not get_parent().is_invincible:
		get_parent().is_invincible = true
