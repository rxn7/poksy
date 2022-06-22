extends Question
class_name PokemonGenerationQuestion

var pokemon_data: PokemonData

func _init(_target_id: int = Global.get_random_generation().get_random_idx()) -> void:
	pokemon_data = PokemonData.load_data(_target_id)
	title = "Z jakiej generacji jest %s?" % pokemon_data.name
	Global.game_manager.pokemon_texture.texture = pokemon_data.load_sprite()
	Global.game_manager.pokemon_texture.self_modulate = Color.white

func get_answers() -> Array:
	var answers = []

	for gen in range(1, Global.generations.size()+1):
		answers.push_back(Answer.new(str(gen), pokemon_data.generation == gen))

	return answers

func on_quessed() -> void:
	pass
