class_name Obstacle extends StaticBody3D

const MAX_X: int = 30

@onready var is_moving_right: bool = randi() % 2
@onready var speed: float = randf_range(10, 25)


func _ready() -> void:
	if not is_moving_right:
		speed = -speed

	change_axis()
	resize()


func resize() -> void:
	pass


func change_direction() -> void:	
	is_moving_right = not is_moving_right
	speed = -speed


func change_axis() -> void:
	rotation.y = deg_to_rad(90 if randi() % 2 else 0)


func _process(delta: float) -> void:
	position.x += speed * delta
	if abs(position.x) >= MAX_X:
		change_direction()
