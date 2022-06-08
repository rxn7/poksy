extends Resource
class_name PokemonData

export var id: int
export var generation: int
export var name: String
export var types: Array

func _init(_name: String = "?", _types: Array = []) -> void:
	name = _name
	types = _types

func load_sprite() -> Texture:
	return load("res://Pokemons/Sprites/%s.png" % id) as Texture

func get_types_translated() -> String:
	var result: String = "";

	for type in types:
		result += PokemonTranslation.get_type_translation(type) + " ";

	return result;

static func load_data(_id: int) -> PokemonData:
	return load("res://Pokemons/Data/%s.tres" % _id) as PokemonData
