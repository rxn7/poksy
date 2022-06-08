extends Node

const GENERATION_1_START: int = 1
const GENERATION_1_END: int = 151
const GENERATION_2_START: int = 152
const GENERATION_2_END: int = 251
const DEV_POKEMONS_DIRECTORY: String = "/home/rxn/dev/godot/poksy/Pokemons"

var random: Random

func _ready() -> void:
	random = Random.new()
	add_child(random)
