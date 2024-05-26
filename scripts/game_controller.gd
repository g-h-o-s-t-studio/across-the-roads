extends Node3D

@export var kill_zone := -50.0
@export var map_size := 8

const TileScene = preload("res://scenes/tiles/tile.tscn")

@onready var _player := $Player as Player
@onready var _tiles: Array[Tile] = [TileScene.instantiate() as Tile]
@onready var _tile_size_z := (
	(_tiles[0].get_node("Mesh") as MeshInstance3D).mesh as BoxMesh
).size.z
@onready var _distance_to_spawn := _tile_size_z + _tile_size_z /2


func _ready() -> void:
	add_child(_tiles[0])
	for i: int in range(map_size):
		_spawn_tile()


func _process(_delta: float) -> void:
	if _player.position.z >= _tiles[0].position.z + _distance_to_spawn:
		_despawn_tile()
		_spawn_tile()

	if _player.position.y <= kill_zone:
		# add after die menu
		get_tree().reload_current_scene()


func _spawn_tile() -> void:
	var new_tile := TileScene.instantiate() as Tile
	new_tile.position.z = _tiles[-1].position.z + _tile_size_z
	add_child(new_tile)
	_tiles.append(new_tile)


func _despawn_tile() -> void:
	(_tiles.pop_front() as Tile).free()
