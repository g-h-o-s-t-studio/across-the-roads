extends Node3D

@export var kill_zone := -50.0
@export var map_size := 8

const Tile = preload("res://scenes/tiles/tile.tscn")

var _spawn_pos_z := _tile_z
var _tiles: Array[StaticBody3D] = [Tile.instantiate() as StaticBody3D]
var _tile_z := (
	(_tiles[0].get_node("Mesh") as MeshInstance3D).mesh as BoxMesh
).size.z
var _distance_to_spawn := _tile_z + _tile_z /2

@onready var player := $Player as Player


func _ready() -> void:
	for i: int in range(map_size):
		_spawn_tile()


func _process(_delta: float) -> void:
	if player.position.z >= _tiles[0].position.z + _distance_to_spawn:
		_despawn_tile()
		_spawn_tile()

	if player.position.y <= kill_zone:
		# add after die menu
		get_tree().reload_current_scene()


func _spawn_tile() -> void:
	var new_tile := Tile.instantiate() as StaticBody3D
	new_tile.position.z = _spawn_pos_z
	add_child(new_tile)
	_tiles.append(new_tile)
	_spawn_pos_z += _spawn_pos_z


func _despawn_tile() -> void:
	(_tiles.pop_front() as StaticBody3D).free()
