extends CharacterBody3D

class_name Guest

signal request_dialogue(dialog : String)

@export var target : Node3D = null
@export var BodyTexture : Resource = null
@export var MaskTexture : Resource = null

#{
# "is_assasin": i<number_of_assasins, 
# "colour": randi_range(0, NUMBER_OF_COLOURS-1), 
# "travel_companions": [],
# "messages": []
#}
var dialogue_data : Dictionary = {}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(target.global_position, Vector3.UP)
	pass


func interact(caller : Node3D) -> void:
	var msg = dialogue_data["messages"][randi_range(0, len(dialogue_data["messages"]) -1)]["text"]
	request_dialogue.emit(msg)

func throw_out() -> void:
	## TODO: Change mask to a blown head sprite and disable physicsbody
	set_physics_process(false)
	visible = false
	
	
