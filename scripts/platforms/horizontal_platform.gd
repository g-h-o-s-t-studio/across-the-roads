class_name HorizontalPlatform extends StaticBody3D

@onready var size := (($Mesh as MeshInstance3D).mesh as BoxMesh).size


func _ready() -> void:
	scale.z = _get_rand_scale_z()


func _get_rand_scale_z() -> int:
	var arr := [20, 30, 40]
	return arr[randi() % arr.size() - 1]
