class_name Answer

const SCENE: PackedScene = preload("res://Scenes/Answer.tscn")

var text: String
var is_correct: bool

func _init(_text: String, _correct: bool) -> void:
	text = _text
	is_correct = _correct

func spawn() -> TextureButton:
	var button: TextureButton = SCENE.instance()
	button.get_node("Label").text = text
	return button
