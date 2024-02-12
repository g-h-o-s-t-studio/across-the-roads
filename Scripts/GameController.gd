extends Node3D

# TODO: add some mechanics(run on wall, changing lvl axis, etc)
const KILL_ZONE: int = -50
const MAP_SIZE: int = 8
const TILE_SIZE: float = 50
const TILE_SCENE: PackedScene = preload("res://Levels/Tiles/Tile.tscn")

var number_tiles: int = 0
var tiles: Array[Node3D] = []


func _ready() -> void:
	for i: int in range(MAP_SIZE):
		spawn_tile()


func _process(_delta: float) -> void:
	if $Player.position.z > tiles[0].position.z + TILE_SIZE / 2:
		despawn_tile()
		spawn_tile()
	
	if $Player.position.y <= KILL_ZONE:
		get_tree().reload_current_scene()


func spawn_tile() -> void:
	var new_tile = TILE_SCENE.instantiate()
	new_tile.position = Vector3(0, 0, number_tiles * TILE_SIZE)
	add_child(new_tile)
	tiles.append(new_tile)
	number_tiles += 1


func despawn_tile() -> void:
	tiles.pop_front().queue_free()
