extends Control


func _on_resume_pressed():
	print('entered')
	get_tree().paused = false
	queue_free()
	print('exit')


func _on_back_to_main_pressed():
	pass # Replace with function body.
