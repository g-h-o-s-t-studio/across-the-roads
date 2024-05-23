extends Control

const PAUSE_MENU: PackedScene = preload(
	"res://Scenes/UserInterface/PauseMenu.tscn"
)

@onready var score = $Score


func _process(_delta: float) -> void:
	score.text = "Score: " + str(ScoreManager.score)


func resume_game() -> void:
	get_tree().paused = false
	var menu_instance = get_node("PauseMenu")
	if menu_instance != null:
		menu_instance.queue_free()

#func toggle_pause() -> void:
	#pause_game() if is_paused else resume_game()


func _on_pause_pressed():
	get_tree().paused = true
	add_child(PAUSE_MENU.instantiate())
