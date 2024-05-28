extends Control

const PauseMenu = preload("res://scenes/ui/pause_menu.tscn")

@onready var _score := $Score as Label


func _process(_delta: float) -> void:
	_score.text = "Score: " + str(ScoreManager.score)


func resume_game() -> void:
	get_tree().paused = false
	var menu_instance := get_node("PauseMenu") 
	if menu_instance != null:
		menu_instance.free()

#func toggle_pause() -> void:
	#pause_game() if is_paused else resume_game()


func _on_pause_pressed() -> void:
	get_tree().paused = true
	add_child(PauseMenu.instantiate())
