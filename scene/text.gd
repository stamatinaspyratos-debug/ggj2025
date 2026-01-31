extends CanvasLayer

var texts: Array[String]
var index = 0
signal finish

func show_text(text: Array[String]):
	texts = text
	index = 0
	$Label.text = texts[index]
	await finish
	queue_free()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		index += 1
		if texts.size() > index:
			$Label.text = texts[index]
		else: finish.emit()
