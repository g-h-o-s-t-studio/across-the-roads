class_name Tile extends StaticBody3D

const CoinScene = preload("res://scenes/items/coin/coin.tscn")
const WallScene = preload("res://scenes/obstacles/wall.tscn")
const MovingCubeScene = preload("res://scenes/obstacles/cube.tscn")
const TriangleScene = preload("res://scenes/platforms/triangle.tscn")
const PlatformScene = preload("res://scenes/platforms/horizontal_platform.tscn")
# WARNING: if mesh size is changed, change this values too
const MESH_SIZE = Vector3(32.0, 2.0, 64.0)
const _HALF_X := MESH_SIZE.x / 2
const _HALF_Z := MESH_SIZE.z / 2

@onready var rc := $RayCast as RayCast3D


func _ready() -> void:
	spawn_triangles_and_platform()
	spawn_staic_obstacles()
	spawn_moving_obstacles()
	spawn_coins()
	rc.free()


func spawn_staic_obstacles() -> void:
	pass

# TODO: реализовать полноценный спавн монеток
func spawn_coins() -> void:
	pass
	#var amount_coins := randi_range(0, 2) * 2 + 3
	#for i: int in range(amount_coins):
		#var coin = COIN.instantiate()
		#coin.position = pm.position + Vector3(0, pm_half_y, i * 2)
		#add_child(coin)

# FIXME
func spawn_triangles_and_platform() -> void:
	var te := TriangleScene.instantiate() as Triangle
	te.position = Vector3(
		randf_range(-_HALF_X + te.size.x / 2, _HALF_X - te.size.x / 2), 
		0,
		randf_range(-_HALF_Z, _HALF_Z)
	)
	add_child(te)
	
	var pm := PlatformScene.instantiate() as HorizontalPlatform
	var pm_half_y := pm.size.y / 2
	var pm_half_z := pm.size.z / 2
	pm.position = Vector3(
		te.position.x, te.size.y - pm_half_y, te.position.z + pm_half_z
	)
	add_child(pm)
	
	te = TriangleScene.instantiate() as Triangle
	te.rotate180()
	te.position = Vector3(pm.position.x, 0, pm.position.z + pm_half_z)
	add_child(te)

	if randi() % 2:
		for i: int in randi_range(0, 2) * 2 + 3:
			var coin := CoinScene.instantiate() as Coin
			coin.position =  pm.position + Vector3(0, pm_half_y, i * 2)
			add_child(coin)


func spawn_moving_obstacles() -> void:
	for i: int in randi_range(10, 20):
		var is_added := false
		var obs := (MovingCubeScene.instantiate() as MovingCube)
		
		for j: int in range(10):
			var y := randf_range(0, 10)
			var z := randf_range(-_HALF_Z, _HALF_Z)
			rc.position = Vector3(MESH_SIZE.x, y, z)
			
			rc.force_raycast_update()
			if rc.is_colliding():
				continue
			
			obs.position = Vector3(randf_range(-_HALF_X, _HALF_X), y, z)
			add_child(obs)
			is_added = true
			break
		
		if not is_added:		
			obs.free()
