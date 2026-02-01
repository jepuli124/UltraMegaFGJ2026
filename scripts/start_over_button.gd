extends Button


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_try_again_button_pressed():
	get_tree().change_scene_to_file("res://scenes/world.tscn")
