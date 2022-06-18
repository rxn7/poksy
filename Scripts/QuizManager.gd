extends Node
class_name QuizManager

const CORRECT_AUDIO_EFFECT: AudioStream = preload("res://Sounds/correct.wav")
const WRONG_AUDIO_EFFECT: AudioStream = preload("res://Sounds/wrong.wav")

onready var background_texture: TextureRect = get_node("Background");
onready var title_label: Label = get_node("Title")
onready var texture: TextureRect = get_node("Texture")
onready var answer_container: Control = get_node("AnswerContainer")
onready var audio_effect_player: AudioStreamPlayer = get_node("AudioEffect")
onready var question_change_timer: Timer = get_node("QuestionChangeTimer")
onready var texture_tween: Tween = get_node("TextureTween")

var current_question: Question

func _ready() -> void:
	Global.quiz_manager = self
	background_texture.texture = Global.get_random_background_texture()
	set_question(get_random_question())

func set_question(_question: Question) -> void:
	current_question = _question
	title_label.text = current_question.title

	# Free previous answers
	for child in answer_container.get_children():
		child.queue_free()
	
	for answer in _question.get_answers():
		var answer_button: TextureButton = answer.spawn()
		answer_button.connect("pressed", self, "on_answer_pressed", [answer.is_correct])
		answer_container.add_child(answer_button)

func get_random_question():
	match(Global.random.rand_i(0, 2)):
		0: return PokemonNameQuestion.new()
		1: return PokemonTypeQuestion.new()
		2: return PokemonGenerationQuestion.new()

	return null

func play_audio_effect(stream: AudioStream, pitch: float = Global.random.rand_f(0.95, 1.05)) -> void:
	audio_effect_player.pitch_scale = pitch 
	audio_effect_player.stream = stream 
	audio_effect_player.play()

func on_answer_pressed(is_correct: bool) -> void:
	if question_change_timer.time_left != 0:
		return

	if is_correct:
		current_question.on_quessed()
		play_audio_effect(CORRECT_AUDIO_EFFECT)
		question_change_timer.wait_time = CORRECT_AUDIO_EFFECT.get_length() / audio_effect_player.pitch_scale 
		question_change_timer.start()
	else:
		play_audio_effect(WRONG_AUDIO_EFFECT)

func on_question_change_timer_timeout():
	question_change_timer.stop()
	set_question(get_random_question())
