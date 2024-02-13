extends Node3D

const OBSTACLES: Array[PackedScene] = [
	preload("res://Models/Obstacles/Cube.tscn"),
	preload("res://Models/Obstacles/Parallelepiped.tscn"),
	preload("res://Models/Obstacles/Wall.tscn")
]
const MAX_X = 30

@export var min_obstacles: int = 10
@export var max_obstacles: int = 25
@onready var rc: RayCast3D = $RayCast
var half_x: float
var half_z: float


func _ready() -> void:
	var mesh_inst: MeshInstance3D = $Tile/Mesh
	var mesh: BoxMesh = mesh_inst.mesh
	half_x = mesh.size.x / 2
	half_z = mesh.size.z / 2
	
	for i: int in range(randi_range(min_obstacles, max_obstacles)):
		var obs = OBSTACLES[randi() % OBSTACLES.size() - 1].instantiate()
		obs.position = get_spawn_position()
		add_child(obs)


func get_spawn_position() -> Vector3:
	var attempt_count: int = 0
	while attempt_count < 10:
		var y: float = randf_range(0, 10)
		var z: float = randf_range(-half_z, half_z)
		rc.position = Vector3(MAX_X, y, z)
		rc.force_raycast_update()
		
		if not rc.is_colliding():
			return Vector3(randf_range(-half_x, half_x), y, z)
		
		attempt_count += 1

	return Vector3.ZERO
