extends Node3D

const GUEST_SCALE_FLOAT : float = 0.42
const GUEST_SCALE : Vector3 = Vector3(GUEST_SCALE_FLOAT, GUEST_SCALE_FLOAT, GUEST_SCALE_FLOAT)

var _generated_list_of_characters : Array 
var _assasins_left : int = Globals.current_level

@onready var dialog_handler : Control = $DialogHandler

const BODY_TEXTURES = [
	preload("res://assets/Sprites/Character/Female1.png"),
	preload("res://assets/Sprites/Character/Female2.png"),
	preload("res://assets/Sprites/Character/Female3.png"),
	preload("res://assets/Sprites/Character/Female4.png"),
	preload("res://assets/Sprites/Character/Female5.png"),
	preload("res://assets/Sprites/Character/Female6.png"),
	preload("res://assets/Sprites/Character/Female7.png"),
	preload("res://assets/Sprites/Character/Female8.png"),
	preload("res://assets/Sprites/Character/Female9.png"),
	preload("res://assets/Sprites/Character/Female10.png"),
	preload("res://assets/Sprites/Character/Male1.png"),
	preload("res://assets/Sprites/Character/Male2.png"),
	preload("res://assets/Sprites/Character/Male3.png"),
	preload("res://assets/Sprites/Character/Male4.png"),
	preload("res://assets/Sprites/Character/Male5.png"),
	preload("res://assets/Sprites/Character/Male6.png"),
	preload("res://assets/Sprites/Character/Male7.png"),
	preload("res://assets/Sprites/Character/Male8.png"),
	preload("res://assets/Sprites/Character/Male9.png"),
	preload("res://assets/Sprites/Character/Male10.png"),
	preload("res://assets/Sprites/Character/Male11.png"),
	preload("res://assets/Sprites/Character/Male12.png")
]

const MASK_TEXTURES = [
	preload("res://assets/Sprites/Masks/Mask1.png"),
	preload("res://assets/Sprites/Masks/Mask2.png"),
	preload("res://assets/Sprites/Masks/Mask3.png"),
	preload("res://assets/Sprites/Masks/Mask4.png"),
	preload("res://assets/Sprites/Masks/Mask5.png"),
	preload("res://assets/Sprites/Masks/Mask7.png"),
	preload("res://assets/Sprites/Masks/Mask8.png"),
	preload("res://assets/Sprites/Masks/Mask11.png"),
	preload("res://assets/Sprites/Masks/Mask12.png"),
	preload("res://assets/Sprites/Masks/Mask15.png"),
	preload("res://assets/Sprites/Masks/Mask16.png")
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_generated_list_of_characters = PuzzleGenerator.generate_puzzle(8, Globals.current_level)
	_set_characters()


#{
# "is_assasin": i<number_of_assasins, 
# "colour": randi_range(0, NUMBER_OF_COLOURS-1), 
# "travel_companions": [],
# "messages": []
#}
func _set_characters() -> void:
	var guests = $Guests.get_children()
	var i = 0
	for chr in _generated_list_of_characters:
		guests[i].dialogue_data = chr
		guests[i].request_dialogue.connect(_on_guest_request_dialogue)
		guests[i].scale = GUEST_SCALE
		var guest_children = guests[i].get_children()
		for child in guest_children:
			if child is Sprite3D:
				child.texture = BODY_TEXTURES[randi_range(0, BODY_TEXTURES.size()-1)]
				child.get_child(0).texture = MASK_TEXTURES[chr["colour"]]
				
		i += 1
		
func _on_guest_request_dialogue(dialog: String) -> void:
	dialog_handler.change_text(dialog)

func _on_guest_guest_thrown_out(is_assasin):
	if not is_assasin:
		get_tree().change_scene_to_file("res://scenes/lose_screen.tscn")
	else:
		_assasins_left -= 1
		if _assasins_left < 1:
			Globals.current_level += 1
			get_tree().change_scene_to_file("res://scenes/world.tscn")
