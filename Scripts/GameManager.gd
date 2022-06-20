extends Node
class_name GameManager

const CORRECT_AUDIO_EFFECT: AudioStream = preload("res://Sounds/correct.wav")
const WRONG_AUDIO_EFFECT: AudioStream = preload("res://Sounds/wrong.wav")
const ANSWER_BUTTON_SCENE: PackedScene = preload("res://Scenes/AnswerButton.tscn")
const CORRECT_PARTICLES_SCENE: PackedScene = preload("res://Scenes/CorrectParticles.tscn")

onready var ui_shaker: Control = get_node("UI")
onready var title_label: Label = ui_shaker.get_node("Title")
onready var pokemon_texture: TextureRect = ui_shaker.get_node("PokemonTexture")
onready var answer_container: Control = ui_shaker.get_node("AnswerContainer")
onready var audio_effect_player: AudioStreamPlayer = get_node("AudioEffect")
onready var question_change_timer: Timer = get_node("QuestionChangeTimer")
onready var texture_tween: Tween = get_node("TextureTween")

var current_question: Question

func _ready() -> void:
	Global.game_manager = self
	set_question(get_random_question())

func set_question(_question: Question) -> void:
	current_question = _question
	title_label.text = current_question.title

	# Free previous answers
	for child in answer_container.get_children():
		child.queue_free()
	
	for answer in _question.get_answers():
		var answer_btn: AnswerButton = ANSWER_BUTTON_SCENE.instance()
		answer_btn.init(answer)
		answer_container.add_child(answer_btn)
		answer_btn.connect("pressed", self, "on_answer_pressed", [answer_btn, answer.is_correct])

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

func on_answer_pressed(btn: AnswerButton, is_correct: bool) -> void:
	if question_change_timer.time_left != 0:
		return

	if is_correct:
		current_question.on_quessed()
		add_child(CORRECT_PARTICLES_SCENE.instance())
		play_audio_effect(CORRECT_AUDIO_EFFECT)
		question_change_timer.wait_time = CORRECT_AUDIO_EFFECT.get_length() / audio_effect_player.pitch_scale 
		question_change_timer.start()
		texture_tween.interpolate_property(pokemon_texture, "rect_position", pokemon_texture.rect_position, Vector2(-1000, pokemon_texture.rect_position.y), question_change_timer.wait_time, Tween.TRANS_EXPO, Tween.EASE_IN)
		texture_tween.interpolate_property(pokemon_texture, "rect_scale", pokemon_texture.rect_scale, Vector2(1.1, 1.1), 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
		texture_tween.start()

		for b in answer_container.get_children():
			b.disable()

	else:
		play_audio_effect(WRONG_AUDIO_EFFECT)
		ui_shaker.shake(50, 0.25)
		btn.disable()

func on_question_change_timer_timeout():
	ui_shaker.shake(15, 0.2)
	question_change_timer.stop()
	texture_tween.interpolate_property(pokemon_texture, "rect_position", pokemon_texture.rect_position, Vector2(0, pokemon_texture.rect_position.y), 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	texture_tween.interpolate_property(pokemon_texture, "rect_scale", pokemon_texture.rect_scale, Vector2(1, 1), 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
	texture_tween.start()
	set_question(get_random_question())
