extends StaticBody3D

const OBSTACLES: Array[PackedScene] = [
	preload("res://Scenes/Obstacles/Cube.tscn"),
	preload("res://Scenes/Obstacles/Parallelepiped.tscn"),
	preload("res://Scenes/Obstacles/Wall.tscn")
]
const TRIANGLE: PackedScene = preload("res://Scenes/Platforms/Triangle.tscn")
const PLATFORM: PackedScene = preload(
	"res://Scenes/Platforms/HorizontalPlatform.tscn"
)

@export var min_obstacles: int = 15
@export var max_obstacles: int = 30
@onready var rc: RayCast3D = $RayCast

var max_x: float
var half_x: float
var half_z: float


func _ready() -> void:
	get_mesh_sizes()
	spawn_triangles_and_platforms()
	spawn_obstacles()


func get_mesh_sizes() -> void:
	var mesh_inst: MeshInstance3D = $Mesh
	var mesh: BoxMesh = mesh_inst.mesh
	max_x = mesh.size.x
	half_x = mesh.size.x / 2
	half_z = mesh.size.z / 2


func spawn_triangles_and_platforms() -> void:
	var triangle = TRIANGLE.instantiate()
	triangle.position = Vector3(
		randf_range(-half_x, half_x), 0, randf_range(-half_z, half_z)
	)
	var y: float = triangle.get_node("Mesh").mesh.size.y
	
	var platform = PLATFORM.instantiate()
	
	add_child(triangle)
	add_child(platform)


func spawn_obstacles() -> void:
	for i: int in range(randi_range(min_obstacles, max_obstacles)):
		var obs = OBSTACLES[randi() % OBSTACLES.size() - 1].instantiate()
		
		var attempt_count: int = 0
		while attempt_count < 10:
			var y: float = randf_range(0, 10)
			var z: float = randf_range(-half_z, half_z)
			rc.position = Vector3(max_x, y, z)
			rc.force_raycast_update()
			
			if not rc.is_colliding():
				obs.position = Vector3(randf_range(-half_x, half_x), y, z)
				add_child(obs)
				break
			
			attempt_count += 1
