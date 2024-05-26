class_name ParallelepipedObstacle extends BaseObstacle


func _ready() -> void:
	super()
	
	scale = Vector3(
		randf_range(1.3, 6.7), randf_range(1.3, 3.5), randf_range(1.5, 4.5)
	)
