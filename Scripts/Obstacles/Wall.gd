class_name WallObstacle extends Obstacle

func resize() -> void:
	var x: float = randf_range(1, 2)
	var y: float = randf_range(1, 2.5)
	var z: float = randf_range(1, 3)
	scale = Vector3(x, y, z)
