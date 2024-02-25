extends StaticBody3D

var size_z: float = randf_range(20, 70)


func _ready() -> void:
	scale.z = size_z


func get_size() -> Vector3:
	return $Mesh.mesh.size
