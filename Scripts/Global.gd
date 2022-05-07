extends Node

var poke_api: PokeApi;
var random: Random

func _ready() -> void:
	poke_api = PokeApi.new()
	add_child(poke_api)

	random = Random.new()
	add_child(random)

	poke_api.request_pokemon(random.i(0, 100));
