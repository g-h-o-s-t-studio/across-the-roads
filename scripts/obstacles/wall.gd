class_name WallObstacle extends BaseObstacle


func resize() -> void:
	scale = Vector3(
		randf_range(3, 10.5), randf_range(2.5, 8.7), randf_range(1, 3.2)
	)
