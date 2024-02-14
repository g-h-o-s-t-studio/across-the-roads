extends Node3D

const KILL_ZONE: int = -50
const MAP_SIZE: int = 8
const TILE_SIZE: float = 50
const TILE_SCENE: PackedScene = preload("res://Scenes/Tiles/Tile.tscn")

@onready var player = $Player
var number_tiles: int = 0
var tiles: Array[Node3D] = []


func _ready() -> void:
	for i: int in range(MAP_SIZE):
		spawn_tile()


func _process(_delta: float) -> void:
	if player.position.z >= tiles[0].position.z + TILE_SIZE:
		despawn_tile()
		spawn_tile()

	if player.position.y <= KILL_ZONE:
		get_tree().reload_current_scene()


func spawn_tile() -> void:
	var new_tile = TILE_SCENE.instantiate() # What's type?
	new_tile.position = Vector3(0, 0, number_tiles * TILE_SIZE)
	add_child(new_tile)
	tiles.append(new_tile)
	number_tiles += 1


func despawn_tile() -> void:
	tiles.pop_front().queue_free()
