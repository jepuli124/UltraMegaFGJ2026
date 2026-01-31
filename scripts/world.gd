extends Node3D

var _generated_list_of_characters : Array 

@onready var dialog_handler : Control = $DialogHandler

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_generated_list_of_characters = PuzzleGenerator.generate_puzzle(8, 2)
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
		i += 1

func _on_guest_request_dialogue(dialog: String) -> void:
	dialog_handler.change_text(dialog)
