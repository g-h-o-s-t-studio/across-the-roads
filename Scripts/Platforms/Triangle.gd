extends StaticBody3D


func get_size() -> Vector3:
	return (($Mesh as MeshInstance3D).mesh as PrismMesh).size


func rotate180() -> void:
	rotate_y(deg_to_rad(180))
