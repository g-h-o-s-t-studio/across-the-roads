extends StaticBody3D

const COIN: PackedScene = preload("res://Scenes/Items/Coin/Coin.tscn")
const OBSTACLES: Array[PackedScene] = [
	preload("res://Scenes/Obstacles/Cube.tscn"),
	preload("res://Scenes/Obstacles/Parallelepiped.tscn"),
	preload("res://Scenes/Obstacles/Wall.tscn"),
]
const TRIANGLE: PackedScene = preload("res://Scenes/Platforms/Triangle.tscn")
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
	spawn_coins()
	spawn_obstacles()
	rc.queue_free()


func get_mesh_sizes() -> void:
	var mesh_inst: MeshInstance3D = $Mesh
	var mesh: BoxMesh = mesh_inst.mesh
	max_x = mesh.size.x
	half_x = mesh.size.x / 2
	half_z = mesh.size.z / 2


# TODO: реализовать полноценный спавн монеток
func spawn_coins() -> void:
	var amount_coins: int = randi_range(0, 2) * 2 + 3
	#for i: int in range(amount_coins):
		#var coin = COIN.instantiate()
		#coin.position = pm.position + Vector3(0, pm_half_y, i * 2)
		#add_child(coin)

# TODO: чекать спавн и если нет уже ниче там, спавним
# +- половина + 14
# TODO! добавить коллизию для трианглов
func spawn_triangles_and_platform() -> void:
	#src.rotate_y(deg_to_rad(90))
	
	var te = TRIANGLE.instantiate()
	var te_size: Vector3 = te.get_size()
	te.position = Vector3(
		randf_range(-half_x + te_size.x / 2, half_x - te_size.x / 2), 
		0,
		randf_range(-half_z, half_z)
	)
	add_child(te)
	
	
	var pm = PLATFORM.instantiate()
	var pm_half_y = pm.get_node("Mesh").mesh.size.y / 2
	var pm_half_z = pm.size_z / 2
	pm.position = Vector3(
		te.position.x, te_size.y - pm_half_y, te.position.z + pm_half_z
	)
	add_child(pm)
	
	te = TRIANGLE.instantiate()
	te.rotate180()
	te.position = Vector3(pm.position.x, 0, pm.position.z + pm_half_z)
	add_child(te)

	if randi() % 2:
		var counter: int = randi_range(0, 2) * 2 + 3
		while counter:
			var coin = COIN.instantiate()
			coin.position =  pm.position + Vector3(0, pm_half_y, counter * 2)
			add_child(coin)
			counter -= 1


func spawn_obstacles() -> void:
	var amount_obs: int = randi_range(MIN_OBS, MAX_OBS)
	while amount_obs:
		var obs = OBSTACLES[randi() % OBSTACLES.size() - 1].instantiate()
		check_pos_and_spawn(obs)
		amount_obs -= 1


func check_pos_and_spawn(obs) -> void:
	var amount_tries: int = 10
	while amount_tries:
		var y: float = randf_range(0, 13)
		var z: float = randf_range(-half_z, half_z)
		rc.position = Vector3(max_x, y, z)
		
		rc.force_raycast_update()
		if not rc.is_colliding():
			obs.position = Vector3(randf_range(-half_x, half_x), y, z)
			return add_child(obs)

		amount_tries -= 1
		
	obs.queue_free()
