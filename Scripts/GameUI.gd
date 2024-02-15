extends Control

@onready var score = $Score


func _process(_delta: float) -> void:
	update_score_label()

func update_score_label() -> void:
	score.text = "Score: " + str(ScoreManager.score)
