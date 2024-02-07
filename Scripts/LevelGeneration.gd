extends Node

const PIECE = preload("res://Levels/Shared/Piece.tscn")
var position = 20
const PIECES_SIZE = 5

func _process(delta):
	var piece = PIECE.instantiate()
	position += 20
	piece.position.x = position
	add_child(piece) 
