extends Control

@export var dialogText = ""
#@onready var textBox := $VBoxContainer/Label
@onready var textBox := $MarginContainer/MarginContainer/Label
@onready var timer := $Timer
@onready var dialog_timer := $DialogueDisappear

var sliceCounter = 0
const letterWaitLength = 0.1

func _ready() -> void:
	textBox.text = dialogText
	visible = false

func change_text(text: String) -> void:
	visible = true
	if (text.length() > 0):
		dialogText = text
	textBox.text = dialogText
	dialog_timer.start()

func change_large_text(text: String) -> void:
	visible = true
	if (text.length() > 0):
		dialogText = text
	sliceCounter = 0
	_on_timer_timeout()

func _on_timer_timeout() -> void:
	var text = dialogText.get_slice("\n", sliceCounter)
	print(text)
	if(text.length() == 0):
		textBox.text = ""
		timer.stop()
		return
	sliceCounter += 1
	textBox.text = text
	timer.wait_time = text.length()*letterWaitLength + 1
	timer.start()


func _on_dialogue_disappear_timeout() -> void:
	visible = false
	textBox.text = ""
	
