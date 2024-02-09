extends Node

const MAP_SIZE: int = 5
const TILE_SIZE: int = 50
const TILE_SCENE: PackedScene = preload("res://Levels/Shared/Tile.tscn")
var number_tiles: int = 1
var tiles: Array[Object] = []

func _ready() -> void:
	for i in range(MAP_SIZE):
		spawn_tile()


func _process(_delta: float) -> void:
	if $Player.position.x > tiles[0].position.x + TILE_SIZE:
		despawn_tile()
		spawn_tile()


func spawn_tile() -> void:
	var new_tile: Object = TILE_SCENE.instantiate()
	new_tile.position = Vector3(number_tiles * TILE_SIZE, 0, 0)
	number_tiles += 1
	add_child(new_tile)
	tiles.append(new_tile)


func despawn_tile() -> void:
	tiles.pop_front().queue_free()
