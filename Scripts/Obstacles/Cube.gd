class_name CubeObstacle extends Obstacle


func resize() -> void:
	var new_size: float = randf_range(0.7, 3.5)
	scale = Vector3(new_size, new_size, new_size)
