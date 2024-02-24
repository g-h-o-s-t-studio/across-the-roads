extends StaticBody3D

var scale_z: float = randf_range(20, 70)

func _ready() -> void:
	scale = Vector3(1, 1, scale_z)
