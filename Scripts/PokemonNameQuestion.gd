extends Question
class_name PokemonNameQuestion

var pokemon_data: PokemonData

func _init(_target_id: int = Global.random.rand_i(Global.GENERATION_1_START, Global.GENERATION_2_END)).("Jaki to pokemon?") -> void:
	pokemon_data = PokemonData.load_data(_target_id)
	Global.quiz_manager.texture.texture = pokemon_data.load_sprite()
	Global.quiz_manager.texture.self_modulate = Color.black
	
func get_answers() -> Array:
	var answers = []

	answers.push_back(Answer.new(pokemon_data.name, true))

	var incorrect_ids: Array = Global.random.rand_i_arr_except(Global.GENERATION_1_START, Global.GENERATION_2_END, 3, pokemon_data.id)

	for i in range(3):
		answers.push_back(Answer.new(PokemonData.load_data(incorrect_ids[i]).name, false))

	randomize()
	answers.shuffle()

	return answers

func on_quessed() -> void:
	Global.quiz_manager.texture_tween.interpolate_property(Global.quiz_manager.texture, "self_modulate", Global.quiz_manager.texture.self_modulate, Color.white, 0.1, Tween.TRANS_LINEAR)
	Global.quiz_manager.texture_tween.start()
	pass
