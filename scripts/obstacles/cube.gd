class_name CubeObstacle extends BaseObstacle


func resize() -> void:
	var new_size := randf_range(0.7, 3)
	scale = Vector3(new_size, new_size, new_size)
