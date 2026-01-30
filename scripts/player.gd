extends CharacterBody3D

const MOUSE_SENS_DIV : int = 1000
const DOWN_ELEVATION : int = 60
const UP_ELEVATION : int = 60

var _mouse_sens_adjusted : float

func _ready():
	_mouse_sens_adjusted = Globals.mouse_sensitivity / MOUSE_SENS_DIV

func _physics_process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		$Camera.rotate_y(-event.relative.x * _mouse_sens_adjusted)
		$Camera.rotate_x(-event.relative.y * _mouse_sens_adjusted)
		$Camera.rotation.x = clampf($Head.rotation.x, -deg_to_rad(DOWN_ELEVATION), deg_to_rad(UP_ELEVATION))

	if event.is_action_pressed("E"):
		print("EEEEEEEEE")
		interact_with()
	
	if event.is_action_pressed("LMB"):
		print("Left")
		pass
	if event.is_action_pressed("RMB"):
		print("Right")
		pass

func interact_with() -> void:
	pass
