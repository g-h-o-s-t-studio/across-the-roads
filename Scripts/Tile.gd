extends Node3D

const OBSTACLES = [
	preload("res://Levels/Obstacles/Square1.tscn"), 
	preload("res://Levels/Obstacles/Rectangle1.tscn")
]
const SPAWN_DISTANCE = 20
const OBSTACLE_SPEED = 2
# TODO: Fix spawn distance
func _ready():
	var right = Node.new()
	var left = Node.new()
	right.name = "RightToLeftObs"
	left.name = "LeftToRightObs"
	add_child(right)
	add_child(left)
	spawn_obstacles(randi_range(3, 10))


func spawn_obstacles(number_obstacles):
	for i in number_obstacles:
		var obs = OBSTACLES[randi() % OBSTACLES.size() - 1].instantiate()
		if randi() % 2 == 0:
			obs.position = Vector3(randf_range(position.x, position.x * 2), 0, -10)
			$RightToLeftObs.add_child(obs)
		else:
			obs.position = Vector3(randf_range(position.x, position.x * 2), 0, 10)
			$LeftToRightObs.add_child(obs)


func move_obstacle(obstacle, new_position):
	obstacle.position.z += new_position
	if abs(obstacle.position.z) > 30:
			obstacle.queue_free()


func _process(delta):
	for obs in $RightToLeftObs.get_children():
		move_obstacle(obs, randf_range(OBSTACLE_SPEED, OBSTACLE_SPEED * 2.5) * delta)
		
	for obs in $LeftToRightObs.get_children():
		move_obstacle(obs, -randf_range(OBSTACLE_SPEED, OBSTACLE_SPEED * 2.5) * delta)
