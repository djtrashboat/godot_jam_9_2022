extends KinematicBody2D
onready var sprite = $AnimatedSprite
#########
var vel = Vector2.ZERO
var life = 2
var count = 0

########################
var path: Array = []
var levelNavigation:Navigation2D = null


func _ready():
	yield(get_tree(), "idle_frame")
	var tree = get_tree()
	if tree.has_group("LevelNavigation"):
		levelNavigation = tree.get_nodes_in_group("LevelNavigation")[0]

func _physics_process(delta):
	if levelNavigation:
		navigate()
	#vel = move_and_slide(vel)
	move_and_slide(vel * 100)

func navigate():
	if path.size()>1:
		vel = global_position.direction_to(path[1])
		if global_position== path[0]:
			path.pop_front()

func generate_path():
	if levelNavigation!=null:
		path = levelNavigation.get_simple_path(global_position, get_parent().global_player_pos, false)

func _on_PathTimer_timeout():
	#print(vel)
	if levelNavigation:
		generate_path()

#######

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
func set_knock(v):
	print("test")

