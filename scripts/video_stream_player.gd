extends VideoStreamPlayer

const LEVEL_TRANSITION_VIDEO_PATHS = [
	"res://assets/videos/fgj2026intro-cboalt.ogv",
	"res://assets/videos/F1.ogv",
	"res://assets/videos/F2.ogv",
	"res://assets/videos/F3.ogv",
	"res://assets/videos/F4.ogv",
	"res://assets/videos/F5.ogv",
	"res://assets/videos/Outro.ogv"
]


func _ready():
	self.stream.file = LEVEL_TRANSITION_VIDEO_PATHS[Globals.current_level - 1]
	self.play()

func _on_finished():
	if Globals.current_level == 6:
		Globals.current_level += 1
		get_tree().change_scene_to_file("res://scenes/level_transition.tscn")
	elif Globals.current_level > 6:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Space"):
		if Globals.current_level < 6:
			get_tree().change_scene_to_file("res://scenes/world.tscn")
