extends Question
class_name PokemonTypeQuestion

var pokemon_data: PokemonData

func _init(_target_id: int = Global.random.rand_i(Global.GENERATION_1_START, Global.GENERATION_2_END)).("") -> void:
	pokemon_data = PokemonData.load_data(_target_id)
	title = "Jakiego typu jest %s?" % pokemon_data.name
	Global.quiz_manager.texture.texture = pokemon_data.load_sprite()
	Global.quiz_manager.texture.self_modulate = Color.white

func get_answers() -> Array:
	var answers = []

	answers.push_back(Answer.new(pokemon_data.get_types_translated(), true))

	for _i in range(3):
		var types: String = ""

		# FIXME: This can lead to infinite loop
		while true:
			var duplicate = false 
			var count = Global.random.rand_i(1, 2)
			types = ""
			for _j in range(count):
				var type: String = ""
				# Make sure the types doesn't repeat, for example "rock rock" or "fairy fairy"
				while type == "" || types.count(type):
					type = PokemonTranslation.type_translations.values()[Global.random.rand_i(0, PokemonTranslation.type_translations.size()-1)]

				types += type + " "

			# Make sure the same exact types aren't present in any other answer
			for ans in answers:
				if ans.text == types:
					duplicate = true
					break

			if !duplicate:
				break

		answers.push_back(Answer.new(types, false))

	randomize()
	answers.shuffle()

	return answers

func on_quessed() -> void:
	pass
