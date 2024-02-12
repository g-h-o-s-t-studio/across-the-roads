class_name ParallelepipedObstacle extends Obstacle


func resize() -> void:
	scale = Vector3(randf_range(0.7, 3.5), randf_range(0.7, 3.5), randf_range(0.7, 3.5))
