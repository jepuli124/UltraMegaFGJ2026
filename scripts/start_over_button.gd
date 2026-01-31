extends Button




func _on_pressed():
	Globals.current_level = 1
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_try_again_button_pressed():
	get_tree().change_scene_to_file("res://scenes/world.tscn")
