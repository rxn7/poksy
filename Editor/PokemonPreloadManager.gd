extends Node
class_name PreloadManager

var start_time: int
var queried_ids: Array

func _ready() -> void:
	print("Preloading Pokemons...")
	start_time = OS.get_system_time_msecs()
	preload_generation(1, Global.GENERATION_1_START, Global.GENERATION_1_END)
	preload_generation(2, Global.GENERATION_2_START, Global.GENERATION_2_END)

func preload_generation(gen: int, from: int, to: int) -> void:
	print("Preloading generation %s" % gen)
	for i in range(from, to+1):
		request_pokemon(i)

func _process(_dt: float) -> void:
	while (get_child_count()*2) < IP.RESOLVER_MAX_QUERIES && queried_ids.size() > 0:
		var id: int = queried_ids.pop_front()
		add_preloader(id)
	
	if(queried_ids.size() == 0 && get_child_count() == 0):
		print("Pokemons has been preloaded, total time: ", OS.get_system_time_msecs() - start_time, "ms")
		get_tree().quit()

func request_pokemon(id: int) -> void:
	queried_ids.push_back(id)

func add_preloader(id: int) -> void:
	var preloader: PokemonPreloader = PokemonPreloader.new(id)
	add_child(preloader)
