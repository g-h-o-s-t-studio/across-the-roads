extends Control


func _on_resume_pressed() -> void:
	print('entered')
	get_tree().paused = false
	free()
	print('exit')


func _on_back_to_main_pressed() -> void:
	pass # Replace with function body.
