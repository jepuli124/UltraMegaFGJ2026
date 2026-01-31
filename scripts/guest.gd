extends CharacterBody3D

class_name Guest

@export var target : Node3D = null

@export var BodyTexture : Resource = null
@export var MaskTexture : Resource = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Body.texture = BodyTexture
	$Body/Mask.texture = MaskTexture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(target.global_position, Vector3.UP)


func interact(caller : Node3D) -> void:
	print("Hello There Traveller!")
	
