extends CharacterBody3D

const MOUSE_SENS_DIV : int = 1000
const DOWN_ELEVATION : int = 60
const UP_ELEVATION : int = 60

var _mouse_sens_adjusted : float

## Used to handle logic between physics_process and input:
var _is_interact_reset : bool = true
var _interaction_target_collider : Node3D = null
@onready var InteractionRay : RayCast3D = $Camera/JustInCaseRayCast
@onready var InteractionNotify : Control = $UI/InteractionNotify
@onready var Camera : Camera3D = $Camera


func _ready():
	_mouse_sens_adjusted = Globals.mouse_sensitivity / MOUSE_SENS_DIV

func _physics_process(delta: float) -> void:
	## Interaction with collider objects:
	## src: https://forum.godotengine.org/t/godot-4-tutorials-on-interactions/36641
	if InteractionRay.is_colliding():
		var col = InteractionRay.get_collider()
		if col != null && col.has_method("interact"):
			InteractionNotify.text = "Press E to ask question"
			_is_interact_reset = false
			_interaction_target_collider = col
		else:
			_interact_reset()
	else:
		_interact_reset()

func _interact_reset() -> void:
	InteractionNotify.text = ""
	_is_interact_reset = true
	_interaction_target_collider = null


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * _mouse_sens_adjusted)
		Camera.rotate_x(-event.relative.y * _mouse_sens_adjusted)
		Camera.rotation.x = clampf(Camera.rotation.x, -deg_to_rad(DOWN_ELEVATION), deg_to_rad(UP_ELEVATION))

	if event.is_action_pressed("E") && not _is_interact_reset:
		_interact_with(_interaction_target_collider)

	if event.is_action_pressed("LMB"):
		print("Left")

	if event.is_action_pressed("RMB"):
		print("Right")


func _interact_with(target : Node3D) -> void:
	target.interact(self)
