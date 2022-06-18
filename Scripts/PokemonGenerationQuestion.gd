extends Question
class_name PokemonGenerationQuestion

var pokemon_data: PokemonData

func _init(_target_id: int = Global.random.rand_i(Global.GENERATION_1_START, Global.GENERATION_2_END)).("") -> void:
	pokemon_data = PokemonData.load_data(_target_id)
	title = "Z jakiej generacji jest %s?" % pokemon_data.name
	Global.quiz_manager.texture.texture = pokemon_data.load_sprite()
	Global.quiz_manager.texture.self_modulate = Color.white

func get_answers() -> Array:
	var answers = []

	answers.push_back(Answer.new(str(pokemon_data.generation), true))
	for gen in Global.random.rand_i_arr_except(1, 2, 1, pokemon_data.generation):
		answers.push_back(Answer.new(str(gen), false))

	randomize()
	answers.shuffle()

	return answers

func on_quessed() -> void:
	pass
