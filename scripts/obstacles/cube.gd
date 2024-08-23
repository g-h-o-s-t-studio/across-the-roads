class_name MovingCube extends BaseObstacle

@onready var _speed := randf_range(9.0, 20.0) if randi() % 2 else -randf_range(9.0, 20.0)


func _ready() -> void:
	if randi() % 2:
		rotation.y = deg_to_rad(90)
	
	match randi() % 3:
		0:
			var new_size := randf_range(0.7, 3)
			scale = Vector3(new_size, new_size, new_size)
		1:
			scale = Vector3(randf_range(1.3, 6.7), randf_range(1.3, 3.5), 
				randf_range(1.5, 4.5))
		_:
			scale = Vector3(randf_range(3, 10.5), randf_range(2.5, 8.7), 
				randf_range(1, 3.2))


func _process(delta: float) -> void:
	position.x += _speed * delta
	if absf(position.x) >= MAX_X:
		_speed = -_speed
