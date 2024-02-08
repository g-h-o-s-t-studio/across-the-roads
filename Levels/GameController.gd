extends Node

const TILE_SCENE = preload("res://Levels/Shared/Tile.tscn")
var tiles = []

#func _ready():
	#for i in range(5):
	#spawn_tile()
#
#func _process(delta):
	#if $Player.position.x > tiles[0].position.x + 20:
		#despawn_tile()
		#spawn_tile()
#
#
#func spawn_tile():
	#var new_tile = TILE_SCENE.instantiate()
	#new_tile.position = Vector3(tiles.size() * 20, 0, 0) # Предполагаемая длина сегмента карты
	#add_child(new_tile)
	#tiles.append(new_tile)
	#
#
#
#func despawn_tile():
	#tiles[0].queue_free()
	#tiles.remove(0)
