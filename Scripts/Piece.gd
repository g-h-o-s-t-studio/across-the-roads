extends StaticBody3D

const OBSTACLES = [
	preload("res://Levels/Obstacles/Square1.tscn"), 
	preload("res://Levels/Obstacles/Rectangle1.tscn")
]
const SPAWN_DISTANCE = 20
const OBSTACLE_SPEED = 5

func _ready():
	var right = Node.new()
	var left = Node.new()
	right.name = "RightToLeftObs"
	left.name = "LeftToRightObs"
	add_child(right)
	add_child(left)


func spawn_obstacles():
	for obs in OBSTACLES:
		obs = obs.instantiate()
		obs.position.x = randf_range(position.x, position.x * 2)
		if randi() % 2 == 0:
			$RightToLeftObs.add_child(obs)
		else:
			$LeftToRightObs.add_child(obs)


func determine_obstacle(obstacle, new_position):
	obstacle.position.z += new_position
	if abs(obstacle.position.z) > 20:
			obstacle.queue_free()


func _process(delta):
	spawn_obstacles()
	var pos = randf_range(OBSTACLE_SPEED, OBSTACLE_SPEED * 2.5) * delta
	for obs in $RightToLeftObs.get_children():
		determine_obstacle(obs, pos)
		
	for obs in $LeftToRightObs.get_children():
		determine_obstacle(obs, -pos)
