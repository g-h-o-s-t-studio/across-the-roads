extends Control


func _on_resume_pressed():
	get_tree().paused = false
	queue_free()


func _on_back_to_main_pressed():
	pass # Replace with function body.
