extends VideoStreamPlayer

const LEVEL_TRANSITION_VIDEO_PATHS = [
	"res://assets/videos/placeholder.ogv",
	"res://assets/videos/placeholder.ogv",
	"res://assets/videos/placeholder.ogv",
	"res://assets/videos/placeholder.ogv",
	"res://assets/videos/placeholder.ogv",
	"res://assets/videos/placeholder.ogv"
	
]

func _ready():
	self.stream.file = LEVEL_TRANSITION_VIDEO_PATHS[Globals.current_level - 1]
	self.play()

func _on_finished():
	if Globals.current_level > 5:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	get_tree().change_scene_to_file("res://scenes/world.tscn")
