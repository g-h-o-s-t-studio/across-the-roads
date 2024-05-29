class_name Tile extends StaticBody3D

const CoinScene = preload("res://scenes/items/coin/coin.tscn")
const WallScene = preload("res://scenes/obstacles/wall.tscn")
const MovingCubeScene = preload("res://scenes/obstacles/cube.tscn")
const TriangleScene = preload("res://scenes/platforms/triangle.tscn")
const PlatformScene = preload("res://scenes/platforms/horizontal_platform.tscn")
# WARNING: if mesh size is changed, change this values too
const MESH_SIZE = Vector3(32.0, 2.0, 64.0)
const _HALF_X = MESH_SIZE.x / 2
const _HALF_Z = MESH_SIZE.z / 2

@onready var rc := $RayCast as RayCast3D


func _ready() -> void:
#	spawn_triangles_and_platform()
	spawn_staic_obstacles()
	spawn_moving_obstacles()
	spawn_coins()
	rc.free()

# TODO: retrying
func spawn_staic_obstacles() -> void:
	var last_pos_z: float
	for i: int in randi_range(1, 5):
		var retry_amount := 2
		var z := randi_range(0, 64)
		while (
			_is_colliding(Vector3(MESH_SIZE.x, 0, z)) or 
			absi(z - last_pos_z) < 5
		):
			z = randi_range(0, 64)
			retry_amount -= 1
			if not retry_amount:
				print("retry block")
				break
				continue
			
		if absi(z - last_pos_z) <= 5:
			continue
		
		last_pos_z = z
		
		var scale_y := 2 if randi() % 2 else 1
		match randi() % 4:
			0: # wall on full tile width
				_create_and_add_wall(Vector3(0, 0, z), Vector3(8, 1, 1))
			1: # 3 wall's
				_create_and_add_wall(Vector3(13, 0, z), Vector3(1.5, scale_y, 1))
				_create_and_add_wall(Vector3(-13, 0, z), Vector3(1.5, scale_y, 1))
				_create_and_add_wall(Vector3(0, 0, z), Vector3(1.5, scale_y, 1))
			2: # 2 wall's
				_create_and_add_wall(Vector3(10, 0, z), Vector3(3, scale_y, 1))
				_create_and_add_wall(Vector3(-10, 0, z), Vector3(3, scale_y, 1))
			_: # small wall on rand x
				_create_and_add_wall(Vector3(randi_range(-14, 14), 0, z), Vector3(1, scale_y, 1))
		
		retry_amount = 2

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
			
			if _is_colliding(Vector3(MESH_SIZE.x, y, z)):
				continue
				
			obs.position = Vector3(randf_range(-_HALF_X, _HALF_X), y, z)
			add_child(obs)
			is_added = true
			break
		
		if not is_added:		
			obs.free()


func _create_and_add_wall(position: Vector3, scale: Vector3) -> void:
	var wall := WallScene.instantiate() as StaticWall
	wall.position = position
	wall.scale = scale
	add_child(wall)


func _is_colliding(positon: Vector3) -> bool:
	rc.position = position
	rc.force_raycast_update()
	return rc.is_colliding()
