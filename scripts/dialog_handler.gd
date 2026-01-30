extends Control

@export var dialogText = ""
@onready var textBox := $VBoxContainer/Label
@onready var timer := $Timer

var sliceCounter = 0
const letterWaitLength = 0.1

func _ready() -> void:
	textBox.text = dialogText

func changeText(text: String) -> void:
	if(text.length() > 0):
		dialogText = text
	textBox.text = dialogText
	
func changeLargeText(text: String) -> void:
	if(text.length() > 0):
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
