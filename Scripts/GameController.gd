extends Node3D

const KILL_ZONE: float = -50.0
const MAP_SIZE: int = 8
const TILE_SCENE: PackedScene = preload("res://Scenes/Tiles/Tile.tscn")

@onready var player: Player = $Player as Player
var tile_size: float = ((TILE_SCENE.instantiate()
	.get_node("Mesh") as MeshInstance3D)
	.mesh as BoxMesh
).size.z
var number_tiles: int = 0
var tiles: Array[Node3D] = []


func _ready() -> void:
	for i: int in range(MAP_SIZE):
		spawn_tile()


func _process(_delta: float) -> void:
	if player.position.z >= tiles[0].position.z + tile_size + tile_size / 2:
		despawn_tile()
		spawn_tile()

	if player.position.y <= KILL_ZONE:
		# add after die menu
		get_tree().reload_current_scene()


func spawn_tile() -> void:
	var new_tile = TILE_SCENE.instantiate()
	new_tile.position.z = number_tiles * tile_size
	add_child(new_tile)
	tiles.append(new_tile)
	number_tiles += 1


func despawn_tile() -> void:
	tiles.pop_front().queue_free()
