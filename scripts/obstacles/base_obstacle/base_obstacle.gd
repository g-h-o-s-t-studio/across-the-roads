class_name BaseObstacle extends StaticBody3D

const MAX_X = 30

var is_moving_right := randi() % 2
var speed := randf_range(10, 25) if is_moving_right else -randf_range(10, 25)


func _ready() -> void:
	change_axis()
	resize()


func resize() -> void:
	pass


func change_direction() -> void:
	is_moving_right = not is_moving_right
	speed = -speed


func change_axis() -> void:
	if randi() % 2:
		rotation.y = deg_to_rad(90)


func _process(delta: float) -> void:
	position.x += speed * delta
	if abs(position.x) >= MAX_X:
		change_direction()
