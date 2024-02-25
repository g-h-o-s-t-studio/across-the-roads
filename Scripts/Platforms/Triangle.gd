extends StaticBody3D


func get_size() -> Vector3:
	return $Mesh.mesh.size


func rotate180() -> void:
	rotate_y(deg_to_rad(180))
