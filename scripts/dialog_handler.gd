extends Control

@export var dialogText = ""
@onready var textBox := $VBoxContainer/Label
@onready var timer := $Timer

var sliceCounter = 0
const letterWaitLength = 0.1

func changeText(text: String) -> void:
	if(text.length() > 0):
		dialogText = text
	textBox.text = dialogText
	
func changeLargeText(text: String) -> void:
	if(text.length() > 0):
		dialogText = text
	sliceCounter = 0
	timer.timeout()
	

func _on_timer_timeout() -> void:
	var text = dialogText.get_slice("\n", sliceCounter)
	if(text.length() == 0):
		textBox.text = ""
		timer.stop()
		return
	sliceCounter += 1
	textBox.text = text
	timer.wait_time(text.length()*letterWaitLength)
	timer.start()
