extends KinematicBody2D
onready var sprite = $AnimatedSprite
onready var spawner = $SpawnTimer

var vel = Vector2.ZERO

var life = 2

var rand = RandomNumberGenerator.new()

func get_hurt():
	life -= 1
	if (life <= 0):
		queue_free()

func _ready():
	pass # Replace with function body.

func _process(delta):
	sprite.play("default")

func _physics_process(delta):
	vel = -(position - get_parent().global_player_pos)
	vel = vel.normalized() * 100
	move_and_slide(vel, Vector2(0.0, -1.0))


func _on_SpawnTimer_timeout():
	var p = get_parent().global_player_pos
	var screen = get_viewport().get_visible_rect().size
	var pos = Vector2(rand.randf_range(p.x - screen.x, p.x + screen.x), rand.randf_range(p.y - 200, p.y - screen.y))
	get_parent().spawn_susbat(pos)
	
