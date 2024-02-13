class_name WallObstacle extends Obstacle


func resize() -> void:
	scale = Vector3(randf_range(1, 2), randf_range(1, 2.5), randf_range(1, 3))
