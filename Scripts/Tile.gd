extends Node3D

const OBSTACLES: Array[PackedScene] = [
	preload("res://Levels/Obstacles/Square1.tscn"), 
	preload("res://Levels/Obstacles/Rectangle1.tscn"),
]
const OBSTACLE_SPEED: int = 5
const MIN_AMOUNT_OBS: int = 10
const MAX_AMOUNT_OBS: int = 25
const MAX_OBSTACLE_POSITION: int = 30
@onready var right_to_left: Node = Node.new()
@onready var left_to_right: Node = Node.new()
@onready var raycast: RayCast3D = $RayCast3D
#
# TODO: Fix bug with raycast
# можно получать начальную позицию тайла по иксу и конечную их их использовать
# в функции рандома
#
func _ready() -> void:
	add_child(right_to_left)
	add_child(left_to_right)
	spawn_obstacles(randi_range(MIN_AMOUNT_OBS, MAX_AMOUNT_OBS))


func get_spawn_position(z: int) -> Vector3:
	raycast.position = Vector3(randf_range(position.x, position.x * 2), 0, z)
	while raycast.is_colliding():
		raycast.position = Vector3(randf_range(position.x, position.x * 2), 0, z)
	return raycast.position


func spawn_obstacles(number_obstacles: int) -> void:
	for i in range(number_obstacles):
		var obs: Object = OBSTACLES[randi() % OBSTACLES.size() - 1].instantiate()
		
		if randi() % 2 == 0:
			obs.position = get_spawn_position(-10)
			right_to_left.add_child(obs)
		else:
			obs.position = get_spawn_position(10)
			left_to_right.add_child(obs)


func move_obstacle(obstacle: StaticBody3D, new_position: float) -> void:
	obstacle.position.z += new_position
	if abs(obstacle.position.z) >= MAX_OBSTACLE_POSITION:
		if obstacle.get_parent() == right_to_left:
			right_to_left.remove_child(obstacle)
			left_to_right.add_child(obstacle)
		else:
			left_to_right.remove_child(obstacle)
			right_to_left.add_child(obstacle)

func _process(delta: float) -> void:
	for obs in right_to_left.get_children():
		move_obstacle(obs, OBSTACLE_SPEED * delta)
		
	for obs in left_to_right.get_children():
		move_obstacle(obs, -OBSTACLE_SPEED * delta)
