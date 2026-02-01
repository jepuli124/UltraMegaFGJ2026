extends Button

func _on_pressed():
	Globals.current_level = 1
	get_tree().change_scene_to_file("res://scenes/level_transition.tscn")
