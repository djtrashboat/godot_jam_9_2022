extends KinematicBody2D
onready var sprite = $AnimatedSprite
onready var line = $Line2D
#########
var vel = Vector2.ZERO
var life = 2
var count = 0
export var speed = 100
onready var _current_speed = speed
var exp_value = 15
var life_chance = 0.3
var rand = RandomNumberGenerator.new()
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
		if global_position == path[0]:
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
	$knock.start(0)

func get_hurt(amount):
	life -= amount
	if life <= 1:
		modulate = Color.red
	if (life <= 0):
		var xpdrop = get_parent().XP_DROP_SCENE.instance()
		xpdrop.global_position = global_position
		xpdrop.exp_value = exp_value
		get_parent().call_deferred("add_child", xpdrop)
		rand.randomize()
		var r = rand.randf_range(0, 1)
		print(r)
		if r < life_chance:
			var lifedrop = get_parent().LIFE_DROP_SCENE.instance()
			lifedrop.global_position = global_position
			get_parent().call_deferred("add_child", lifedrop)
		
		die()

func _on_knock_timeout():
	_current_speed = speed
	generate_path()

func die():
	queue_free()
