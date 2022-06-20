extends Button
class_name AnswerButton

const CORRECT_STYLE = preload("res://Styles/answer_button_correct_style.tres")
var answer: Answer

func init(_answer: Answer) -> void:
	answer = _answer

func _ready():
	text = answer.text

func disable() -> void:
	disabled = true

	if !answer.is_correct:
		modulate = Color.red
	else:
		add_stylebox_override("disabled", CORRECT_STYLE)
