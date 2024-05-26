class_name BaseObstacle extends StaticBody3D

const MAX_X = 30

@onready var _speed := randf_range(10.0, 25.0) if randi() % 2 else -randf_range(10.0, 25.0)


func _ready() -> void:
	if randi() % 2:
		rotation.y = deg_to_rad(90)


func _process(delta: float) -> void:
	position.x += _speed * delta
	var pos_x := position.x
	if absf(pos_x) >= MAX_X:
		_speed = -_speed
