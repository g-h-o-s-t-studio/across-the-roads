extends Node3D

const MAX_OBS_POSITION: int = 20
#const OBSTACLES: Array[PackedScene] = [
	#preload("res://Levels/Obstacles/Square1.tscn"), 
	#preload("res://Levels/Obstacles/Rectangle1.tscn"),
#]
@export var min_amount_obs: int = 10
@export var max_amount_obs: int = 25
@export var min_obs_speed: int = 5
@export var max_obs_speed: int = 15
@onready var mesh = $Tile/Mesh.mesh
@onready var right_to_left: Node3D = Node3D.new()
@onready var left_to_right: Node3D = Node3D.new()
@onready var raycast: RayCast3D = $RayCast
var obstacles_speed: Dictionary = {}


func _ready() -> void:
	add_child(right_to_left)
	add_child(left_to_right)
	spawn_obstacles(randi_range(min_amount_obs, max_amount_obs))


func get_spawn_vector() -> Vector3:
	var half_x: float = mesh.size.x / 2
	var half_y: float = mesh.size.y / 2
	return Vector3(
		randf_range(position.x - half_x, position.x + half_x), 
		randf_range(0, 10),
		randf_range(position.y - half_y, position.y + half_y)
	)


func get_spawn_position() -> Vector3:
	raycast.position = get_spawn_vector()
	while raycast.is_colliding():
		raycast.position = get_spawn_vector()
	return raycast.position


func spawn_obstacles(number_obstacles: int) -> void:
	for i: int in range(number_obstacles):
		var obs = load("res://Levels/Obstacles/Square.tscn").instantiate()
		#var obs = SquareObstacle.new()
		# var obs: StaticBody3D = OBSTACLES[randi() % OBSTACLES.size() - 1].instantiate()
		obs.position = get_spawn_position()
		right_to_left.add_child(obs) if randi() % 2 == 0 else left_to_right.add_child(obs)

		obstacles_speed[obs] = randf_range(5, 15)


func move_obstacle(obstacle, new_position: float) -> void:
	obstacle.position.z += new_position
	if abs(obstacle.position.z) >= MAX_OBS_POSITION:
		if obstacle.get_parent() == right_to_left:
			right_to_left.remove_child(obstacle)
			left_to_right.add_child(obstacle)
		else:
			left_to_right.remove_child(obstacle)
			right_to_left.add_child(obstacle)


func _process(delta: float) -> void:
	for obs in right_to_left.get_children():
		move_obstacle(obs, obstacles_speed[obs] * delta)
		
	for obs in left_to_right.get_children():
		move_obstacle(obs, -obstacles_speed[obs] * delta)
