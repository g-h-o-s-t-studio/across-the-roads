class_name Triangle extends StaticBody3D

@onready var size := (($Mesh as MeshInstance3D).mesh as PrismMesh).size


func rotate180() -> void:
	rotate_y(deg_to_rad(180))
