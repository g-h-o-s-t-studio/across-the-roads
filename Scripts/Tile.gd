extends StaticBody3D

const COIN: PackedScene = preload("res://Scenes/Items/Coin/Coin.tscn")
const OBSTACLES: Array[PackedScene] = [
	preload("res://Scenes/Obstacles/Cube.tscn"),
	preload("res://Scenes/Obstacles/Parallelepiped.tscn"),
	preload("res://Scenes/Obstacles/Wall.tscn"),
]
const TRIANGLE: PackedScene = preload(
	"res://Scenes/Platforms/Triangle.tscn"
)
const PLATFORM: PackedScene = preload(
	"res://Scenes/Platforms/HorizontalPlatform.tscn"
)
const MIN_OBS: int = 20
const MAX_OBS: int = 35

@onready var rc: RayCast3D = $RayCast
var max_x: float
var half_x: float
var half_z: float


func _ready() -> void:
	get_mesh_sizes()
	spawn_triangles_and_platform()
	spawn_obstacles()


func get_mesh_sizes() -> void:
	var mesh_inst: MeshInstance3D = $Mesh
	var mesh: BoxMesh = mesh_inst.mesh
	max_x = mesh.size.x
	half_x = mesh.size.x / 2
	half_z = mesh.size.z / 2


func spawn_coins() -> void:
	pass


func spawn_triangles_and_platform() -> void:
	var te = TRIANGLE.instantiate()
	var te_size: Vector3 = te.get_node("Mesh").mesh.size
	te.position = Vector3(
		randf_range(-half_x + te_size.x / 2, half_x - te_size.x / 2), 
		0, 
		randf_range(-half_z, half_z)
	)
	add_child(te)
	
	var pm = PLATFORM.instantiate()
	var pm_half_y = pm.get_node("Mesh").mesh.size.y / 2
	pm.position = Vector3(
		te.position.x,
		te_size.y - pm_half_y,
		te.position.z + pm.scale_z / 2
	)
	add_child(pm)
	
	te = TRIANGLE.instantiate()
	te.rotate180()
	te.position = Vector3(
		pm.position.x,
		0,
		pm.position.z + pm.scale_z / 2
	)
	add_child(te)

	if randi() % 2:
		var amount_coins: int = randi_range(0, 2) * 2 + 3
		for i: int in range(amount_coins):
			var coin = COIN.instantiate()
			coin.position = pm.position + Vector3(0, pm_half_y, i * 2)
			add_child(coin)


func spawn_obstacles() -> void:
	for i: int in range(randi_range(MIN_OBS, MAX_OBS)):
		var obs = OBSTACLES[randi() % OBSTACLES.size() - 1].instantiate()
		
		var attempt_count: int = 0
		while attempt_count < 10:
			var y: float = randf_range(0, 13)
			var z: float = randf_range(-half_z, half_z)
			rc.position = Vector3(max_x, y, z)
			rc.force_raycast_update()
			
			if not rc.is_colliding():
				obs.position = Vector3(randf_range(-half_x, half_x), y, z)
				add_child(obs)
				break
			
			attempt_count += 1
