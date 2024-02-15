extends Node


@onready var score: int = 0
@onready var coins: int = 0


func save_data() -> void:
	var file = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
	file.store_var(coins)
	file.store_var(score)
	file.close()
