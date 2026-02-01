extends CharacterBody3D

signal clear_dialogue()

const MOUSE_SENS_DIV : int = 1000
const DOWN_ELEVATION : int = 60
const UP_ELEVATION : int = 60

var _mouse_sens_adjusted : float

## Used to handle logic between physics_process and input:
var _is_interact_reset : bool = true
var _is_throwout_going_on : bool = false
var _interaction_target_collider : Node3D = null
@onready var InteractionRay : RayCast3D = $Camera/JustInCaseRayCast
@onready var Camera : Camera3D = $Camera
@onready var shakeAnim : AnimationPlayer = $CamShake

@onready var AssasinsLeft : Label = $MarginContainer/AssasinsLeft
@onready var reticle_animator: AnimatedSprite2D = $UI/ReticleCenter/Reticle
@onready var InteractionNotify: Label = $UI/ReticleCenter/InteractionNotify
@onready var animated_sprite: AnimatedSprite2D = $UI/Control/ThrowOutAnimation
@onready var line_2d: Line2D = $UI/ReticleCenter/Line2D


var target_to_throw : Node3D = null

func _ready():
	## Capture mouse cursor:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	_mouse_sens_adjusted = Globals.mouse_sensitivity / MOUSE_SENS_DIV
	animated_sprite.visible = false
	reticle_animator.visible = false

func _physics_process(delta: float) -> void:
	## Interaction with collider objects:
	## src: https://forum.godotengine.org/t/godot-4-tutorials-on-interactions/36641
	if InteractionRay.is_colliding():
		var col = InteractionRay.get_collider()
		if col != null && col.has_method("interact"):
			if _is_interact_reset:
				InteractionNotify.text = "Press E to ask question\nPress Q to throw out"
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

func update_assasin_count(assasins_left) -> void:
	AssasinsLeft.text = "Uninvited quests left: " + str(assasins_left) 

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	## Return early in case of throwing out
	if _is_throwout_going_on:
		return
		
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * _mouse_sens_adjusted)
		Camera.rotate_x(-event.relative.y * _mouse_sens_adjusted)
		Camera.rotation.x = clampf(Camera.rotation.x, -deg_to_rad(DOWN_ELEVATION), deg_to_rad(UP_ELEVATION))

	if event.is_action_pressed("E") && not _is_interact_reset:
		_interact_with(_interaction_target_collider)
	if event.is_action_pressed("Q") && not _is_interact_reset:
		_throw_out(_interaction_target_collider)

## this is quality function that is very much modular
func _throw_out(target : Node3D) -> void:
	_is_throwout_going_on = true
	animated_sprite.visible = true
	reticle_animator.visible = true
	line_2d.visible = false
	look_at(target.global_position)
	InteractionNotify.text = ""
	clear_dialogue.emit()
	animated_sprite.play("throw_out")
	reticle_animator.play("throwoutreticle")
	target_to_throw = target

func _interact_with(target : Node3D) -> void:
	target.interact(self)

func _on_reticle_animation_finished() -> void:
	shakeAnim.play("shake")
	reticle_animator.play("final")
	await shakeAnim.animation_finished
	reticle_animator.visible = false
	_is_throwout_going_on = false

func _on_throw_out_animation_animation_finished() -> void:
	target_to_throw.throw_out()
	animated_sprite.visible = false
	_is_throwout_going_on = false
