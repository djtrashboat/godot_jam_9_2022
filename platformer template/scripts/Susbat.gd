extends KinematicBody2D
onready var sprite = $AnimatedSprite
onready var line = $Line2D
#########
var vel = Vector2.ZERO
var life = 2
var count = 0
export var speed = 100
onready var _current_speed = speed

########################
var path: Array = []
var levelNavigation:Navigation2D = null


func _ready():
	yield(get_tree(), "idle_frame")
	var tree = get_tree()
	if tree.has_group("LevelNavigation"):
		levelNavigation = tree.get_nodes_in_group("LevelNavigation")[0]

func _physics_process(delta):
	#line.global_position = Vector2.ZERO
	if levelNavigation:
		navigate()
	move_and_slide(vel * _current_speed)

func navigate():
	if path.size() > 1:
		vel = global_position.direction_to(path[1])
		if global_position== path[0]:
			path.pop_front()

func generate_path():
	if levelNavigation!=null:
		path = levelNavigation.get_simple_path(global_position, get_parent().global_player_pos, false)
		#line.points = path

func _on_PathTimer_timeout():
	if levelNavigation:
		generate_path()

#######

func knockout():
	_current_speed = -speed
	yield(get_tree().create_timer(0.08), "timeout")
	_current_speed = speed
	generate_path()

func get_hurt(amount):
	life -= amount
	modulate = Color.red
	if (life <= 0):
		queue_free()

#func _physics_process(delta):
#	vel = -(position - get_parent().global_player_pos)
#	vel = vel.normalized() * 100
#	move_and_slide(vel, Vector2(0.0, -1.0))
#
