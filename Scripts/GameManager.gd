extends Node
class_name GameManager

const CORRECT_AUDIO_EFFECT: AudioStream = preload("res://Sounds/correct.wav")
const WRONG_AUDIO_EFFECT: AudioStream = preload("res://Sounds/wrong.wav")
const TRANSITION_AUDIO_EFFECT: AudioStream = preload("res://Sounds/transition.wav")
const LOSE_AUDIO_EFFECT: AudioStream = preload("res://Sounds/lose.wav")
const ANSWER_BUTTON_SCENE: PackedScene = preload("res://Scenes/AnswerButton.tscn")
const CORRECT_PARTICLES_SCENE: PackedScene = preload("res://Scenes/CorrectParticles.tscn")
const MAX_LIVES: int = 3

signal lives_changed

onready var ui_shaker: Control = get_node("UI")
onready var title_label: Label = ui_shaker.get_node("Title")
onready var pokemon_texture: TextureRect = ui_shaker.get_node("PokemonTexture")
onready var answer_container: Control = ui_shaker.get_node("AnswerContainer")
onready var score_label: Label = ui_shaker.get_node("Score")
onready var texture_tween: Tween = get_node("TextureTween")
onready var question_change_timer: Timer = get_node("QuestionChangeTimer")
onready var lose_timer: Timer = get_node("LoseTimer")

var lives: int = MAX_LIVES
var score: int = 0

var current_question: Question

func _ready() -> void:
	Global.game_manager = self
	connect("lives_changed", ui_shaker.get_node("Lives"), "on_lives_changed")
	set_question(get_random_question())
	emit_signal("lives_changed", lives, MAX_LIVES)

func on_lose() -> void:
	lose_timer.start()
	SoundManager.play(LOSE_AUDIO_EFFECT)
	for b in answer_container.get_children():
		b.disable()

	if Global.load_highest_score() < score:
		Global.save_highest_score(score)

func on_lose_timer_timeout() -> void:
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

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

func on_answer_pressed(btn: AnswerButton, is_correct: bool) -> void:
	if question_change_timer.time_left != 0:
		return

	if is_correct:
		score += 1
		score_label.text = "Wynik: %s" % score

		current_question.on_quessed()
		add_child(CORRECT_PARTICLES_SCENE.instance())

		var pitch: float = Global.random.rand_f(0.9, 1.1)
		SoundManager.play(CORRECT_AUDIO_EFFECT, pitch)
		question_change_timer.wait_time = CORRECT_AUDIO_EFFECT.get_length() / pitch
		question_change_timer.start()

		texture_tween.interpolate_property(pokemon_texture, "rect_position", pokemon_texture.rect_position, Vector2(-1000, pokemon_texture.rect_position.y), question_change_timer.wait_time, Tween.TRANS_EXPO, Tween.EASE_IN)
		texture_tween.interpolate_property(pokemon_texture, "rect_scale", pokemon_texture.rect_scale, Vector2(1.1, 1.1), 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
		texture_tween.start()

		for b in answer_container.get_children():
			b.disable()
	else:
		SoundManager.play(WRONG_AUDIO_EFFECT, Global.random.rand_f(0.9, 1.1))

		ui_shaker.shake(50, 0.25)
		btn.disable()

		lives -= 1
		if lives == 0:
			on_lose()

		emit_signal("lives_changed", lives, MAX_LIVES)

func on_question_change_timer_timeout():
	ui_shaker.shake(15, 0.2)
	#transition_audio_player.play()

	SoundManager.play(TRANSITION_AUDIO_EFFECT, Global.random.rand_f(0.9, 1.1))

	question_change_timer.stop()
	texture_tween.interpolate_property(pokemon_texture, "rect_position", pokemon_texture.rect_position, Vector2(0, pokemon_texture.rect_position.y), 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	texture_tween.interpolate_property(pokemon_texture, "rect_scale", pokemon_texture.rect_scale, Vector2(1, 1), 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
	texture_tween.start()
	set_question(get_random_question())
