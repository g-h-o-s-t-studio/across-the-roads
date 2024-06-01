class_name Tile extends StaticBody3D

const CoinScene = preload("res://scenes/items/coin/coin.tscn")
const WallScene = preload("res://scenes/obstacles/wall.tscn")
const MovingCubeScene = preload("res://scenes/obstacles/cube.tscn")
const TriangleScene = preload("res://scenes/platforms/triangle.tscn")
const PlatformScene = preload("res://scenes/platforms/horizontal_platform.tscn")

const AMOUNT_RETRYING = 3
const COINS_DISTANCE = 2
const MIN_WALLS_DISTANCE = 7

var amount_mov_obs := randi_range(8, 18)

@onready var rc := $RayCast as RayCast3D
@onready var mesh_size := (($Mesh as MeshInstance3D).mesh as BoxMesh).size
@onready var x := int(mesh_size.x / 2 - 7)
@onready var z := int(mesh_size.z / 2 - 7)


func _ready() -> void:
	spawn_staic_obstacles()
	spawn_coins()
	#spawn_triangles_and_platform()
	spawn_moving_obstacles()
	rc.free()


func spawn_staic_obstacles() -> void:
	var previous_z := {}
	for i: int in randi_range(1, 5):
		var spawn_z := _find_z_for_wall_spawn(previous_z)
		if spawn_z == -1:
			continue
		
		previous_z[spawn_z] = null
		
		var scale_y := 2 if randi() % 2 else 1
		
		match randi() % 4:
			0:  # wall on full tile width
				_add_wall(Vector3(0, 0, spawn_z), Vector3(8, 1, 1))
			1:  # 3 wall's
				_add_wall(Vector3(13, 0, spawn_z), Vector3(1.5, scale_y, 1))
				_add_wall(Vector3(-13, 0, spawn_z), Vector3(1.5, scale_y, 1))
				_add_wall(Vector3(0, 0, spawn_z), Vector3(1.5, scale_y, 1))
			2:  # 2 wall's
				_add_wall(Vector3(10, 0, spawn_z), Vector3(3, scale_y, 1))
				_add_wall(Vector3(-10, 0, spawn_z), Vector3(3, scale_y, 1))
			_:  # small wall on rand x
				_add_wall(Vector3(randi_range(-14, 14), 0, spawn_z), 
					Vector3(1, scale_y, 1))


# рейкастом проверять, не врезаемся ли мы в объект
func spawn_coins() -> void:
	var start_pos := Vector3(randf_range(-x, x), 0, randf_range(-z, z))
	var angle := -PI / 6 if randi() % 2 else PI / 6  # -45 or 45 degrees
	var direction := bool(randi() % 2)
	#if _is_colliding()
	for i: int in randi_range(0, 2) * 2 + 3:
		var offset := COINS_DISTANCE * i
		var new_pos := start_pos + (
			Vector3(offset * sin(angle), 0, offset * cos(angle))
			if direction else Vector3(0, 0, offset)
		)
		if absi(new_pos.x) > x or absi(new_pos.z) > z:
			continue
		
		var coin := CoinScene.instantiate() as Coin
		coin.position = new_pos
		add_child(coin)


# FIXME
func spawn_triangles_and_platform() -> void:
	var te := TriangleScene.instantiate() as Triangle
	te.position = Vector3(
		randf_range(-x + te.size.x / 2, x - te.size.x / 2), 
		0,
		randf_range(-z, z)
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
	te.rotate_y(PI)
	te.position = Vector3(pm.position.x, 0, pm.position.z + pm_half_z)
	add_child(te)

	if not randi() % 3:  # Optionally spawn coins on the platform
		for i: int in randi_range(0, 2) * 2 + 3:
			var coin := CoinScene.instantiate() as Coin
			coin.position = pm.position + Vector3(
				0, pm_half_y, COINS_DISTANCE * 2
			)
			add_child(coin)


func spawn_moving_obstacles() -> void:
	for i: int in amount_mov_obs:
		for j: int in range(AMOUNT_RETRYING):
			var spawn_y := randi_range(0, 10)
			var spawn_z := randi_range(-z, z)
			if not _is_colliding(Vector3(0, spawn_y, spawn_z)):	
				var obs := MovingCubeScene.instantiate() as MovingCube
				obs.position = Vector3(randi_range(-x, x), spawn_y, spawn_z)
				add_child(obs)
				break


func _add_wall(_positon: Vector3, _scale: Vector3) -> void:
	var wall := WallScene.instantiate() as StaticWall
	wall.position = _positon
	wall.scale = _scale
	add_child(wall)


func _find_z_for_wall_spawn(previous_z: Dictionary) -> int:
	for i: int in range(AMOUNT_RETRYING):
		var pos := randi_range(-z + MIN_WALLS_DISTANCE, z - MIN_WALLS_DISTANCE)
		var is_can_spawn := true
		for k: int in previous_z.keys():
			if absi(pos - k) < MIN_WALLS_DISTANCE:
				is_can_spawn = false
				break
		if is_can_spawn and not _is_colliding(Vector3(32, 0, pos)):
			return pos
	return -1


func _is_colliding(pos: Vector3, target: Vector3 = Vector3(-32, 0, 0)) -> bool:
	rc.position = pos
	rc.target_position = target
	rc.force_raycast_update()
	return rc.is_colliding()
