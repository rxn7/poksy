extends Button
class_name AnswerButton

const CORRECT_STYLE = preload("res://Styles/answer_button_correct_style.tres")

var answer: Answer
onready var tween: Tween = get_node("Tween")

func init(_answer: Answer) -> void:
	answer = _answer

func _ready():
	text = answer.text

func disable() -> void:
	disabled = true

	if !answer.is_correct:
		tween.interpolate_property(self, "modulate", modulate, Color.red, 0.2)
		tween.start()
	else:
		add_stylebox_override("disabled", CORRECT_STYLE)
