extends Question
class_name PokemonNameQuestion

var pokemon_data: PokemonData

func _init(_target_id: int = Global.get_random_generation().get_random_idx()) -> void:
	pokemon_data = PokemonData.load_data(_target_id)
	title = "Jak się nazywa ten pokemon?"
	Global.game_manager.pokemon_texture.texture = pokemon_data.load_sprite()
	Global.game_manager.pokemon_texture.self_modulate = Color.black
	
func get_answers() -> Array:
	var answers = []

	answers.push_back(Answer.new(pokemon_data.name, true))

	var incorrect_ids: Array = Global.random.rand_i_arr_except(Global.generations[0].start_idx, Global.generations[Global.generations.size()-1].end_idx, 5, pokemon_data.id)
	for i in range(5):
		answers.push_back(Answer.new(PokemonData.load_data(incorrect_ids[i]).name, false))

	randomize()
	answers.shuffle()

	return answers

func on_quessed() -> void:
	Global.game_manager.texture_tween.interpolate_property(Global.game_manager.pokemon_texture, "self_modulate", Global.game_manager.pokemon_texture.self_modulate, Color.white, 0.1, Tween.TRANS_LINEAR)
	Global.game_manager.texture_tween.start()
