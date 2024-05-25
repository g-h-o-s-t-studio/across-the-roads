extends StaticBody3D

const CoinScene = preload("res://scenes/items/coin/coin.tscn")
const ObstaclesScenes: Array[PackedScene] = [
	preload("res://scenes/obstacles/cube.tscn"),
	preload("res://scenes/obstacles/parallelepiped.tscn"),
	preload("res://scenes/obstacles/wall.tscn"),
]
const TriangleScene = preload("res://scenes/platforms/triangle.tscn")
const PlatformScene = preload("res://scenes/platforms/horizontal_platform.tscn")

const MIN_OBS = 20
const MAX_OBS = 35

var _max_x: float
var _half_x: float
var _half_z: float

@onready var rc := $RayCast as RayCast3D


func _ready() -> void:
	get_mesh_sizes()
	spawn_triangles_and_platform()
	spawn_coins()
	spawn_obstacles()
	rc.free()


func get_mesh_sizes() -> void:
	var size := (($Mesh as MeshInstance3D).mesh as BoxMesh).size
	_max_x = size.x
	_half_x = size.x / 2
	_half_z = size.z / 2


# TODO: реализовать полноценный спавн монеток
func spawn_coins() -> void:
	var amount_coins := randi_range(0, 2) * 2 + 3
	#for i: int in range(amount_coins):
		#var coin = COIN.instantiate()
		#coin.position = pm.position + Vector3(0, pm_half_y, i * 2)
		#add_child(coin)

# TODO: чекать спавн и если нет уже ниче там, спавним
# +- половина + 14
# TODO! добавить коллизию для трианглов
func spawn_triangles_and_platform() -> void:
	#src.rotate_y(deg_to_rad(90))
	var te := TriangleScene.instantiate() as Triangle
	var te_size := te.get_size()
	te.position = Vector3(
		randf_range(-_half_x + te_size.x / 2, _half_x - te_size.x / 2), 
		0,
		randf_range(-_half_z, _half_z)
	)
	add_child(te)
	
	var pm := PlatformScene.instantiate() as HorizontalPlatform
	var pm_half_y := (
		(pm.get_node("Mesh") as MeshInstance3D).mesh as BoxMesh
	).size.y / 2
	var pm_half_z := pm.size_z / 2
	pm.position = Vector3(
		te.position.x, te_size.y - pm_half_y, te.position.z + pm_half_z
	)
	add_child(pm)
	
	te = TriangleScene.instantiate() as Triangle
	te.rotate180()
	te.position = Vector3(pm.position.x, 0, pm.position.z + pm_half_z)
	add_child(te)

	if randi() % 2:
		var counter := randi_range(0, 2) * 2 + 3
		while counter:
			var coin := CoinScene.instantiate() as Coin
			coin.position =  pm.position + Vector3(0, pm_half_y, counter * 2)
			add_child(coin)
			counter -= 1


func spawn_obstacles() -> void:
	var amount_obs := randi_range(MIN_OBS, MAX_OBS)
	while amount_obs:
		check_pos_and_spawn(
			ObstaclesScenes[randi() % ObstaclesScenes.size() - 1]
			.instantiate() as BaseObstacle
		)
		amount_obs -= 1


func check_pos_and_spawn(obs: BaseObstacle) -> void:
	for i: int in range(10):
		var y := randf_range(0, 13)
		var z := randf_range(-_half_z, _half_z)
		rc.position = Vector3(_max_x, y, z)
		
		rc.force_raycast_update()
		if not rc.is_colliding():
			obs.position = Vector3(randf_range(-_half_x, _half_x), y, z)
			return add_child(obs)

	obs.free()
