extends Control

const PAUSE_MENU: PackedScene = preload(
	"res://Scenes/UserInterface/PauseMenu.tscn"
)

var is_paused: bool = false
@onready var score = $Score


func _process(_delta: float) -> void:
	update_score_label()


func update_score_label() -> void:
	score.text = "Score: " + str(ScoreManager.score)


func pause_game() -> void:
	is_paused = true
	get_tree().paused = true
	var menu_instance = PAUSE_MENU.instantiate()
	add_child(menu_instance)


func resume_game() -> void:
	is_paused = false
	get_tree().paused = false
	var menu_instance = get_node("PauseMenu")
	if menu_instance != null:
		menu_instance.queue_free()

#func toggle_pause() -> void:
	#pause_game() if is_paused else resume_game()


func _on_pause_pressed():
	pause_game()
