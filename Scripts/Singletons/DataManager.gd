extends Node


const SAVE_PATH: String = "user://save_game.dat"

@onready var score: int = 0: set = _set_score, get = _get_score
@onready var coins: int = 0: set = _set_coins, get = _get_coins


func _set_score(value: int) -> void:
	score = value
	save_data()


func _get_score() -> int:
	return score
	
	
func _set_coins(value: int) -> void:
	coins = value
	save_data()
	
	
func _get_coins() -> int:
	return coins


func save_data():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_32(coins)
	file.store_32(score)


func load_data():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		coins = file.get_32()
		score = file.get_32()
