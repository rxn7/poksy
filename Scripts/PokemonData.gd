extends Resource
class_name PokemonData

enum PokemonType {
	Normal = 1 << 0,
	Fire = 1 << 1,
	Water = 1 << 2,
	Electric = 1 << 3,
	Grass = 1 << 4,
	Ice = 1 << 5,
	Fighting = 1 << 6,
	Poison = 1 << 7,
	Ground = 1 << 8,
	Flying = 1 << 9,
	Psychic = 1 << 10,
	Bug = 1 << 11,
	Rock = 1 << 12,
	Ghost = 1 << 13,
	Dragon = 1 << 14,
	Dark = 1 << 15,
	Steel = 1 << 16,
	Fairy = 1 << 17
}

export var id: int
export var generation: int
export var name: String
export var spriteUrl: String
export var type: int = PokemonType.Normal | PokemonType.Rock

func _init(_name: String = "?", _spriteUrl: String = "?", _type: int = PokemonType.Normal) -> void:
	name = _name
	spriteUrl = _spriteUrl
	type = _type

static func get_type_from_string(_type: String) -> int:
	match _type:
		"normal": return PokemonType.Normal
		"water": return PokemonType.Water
		"electric": return PokemonType.Electric
		"grass": return PokemonType.Grass
		"ice": return PokemonType.Ice
		"fighting": return PokemonType.Fighting
		"poison": return PokemonType.Poison
		"ground": return PokemonType.Ground
		"flying": return PokemonType.Flying
		"psychic": return PokemonType.Psychic
		"bug": return PokemonType.Bug
		"rock": return PokemonType.Rock
		"ghost": return PokemonType.Ghost
		"dragon": return PokemonType.Dragon
		"dark": return PokemonType.Dark
		"steel": return PokemonType.Steel
		"fairy": return PokemonType.Fairy
		_: return PokemonType.Normal
