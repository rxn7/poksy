extends Node
class_name PreloadManager

var start_time: int
var queried_ids: Array

func _ready() -> void:
	print("Preloading Pokemons...")
	start_time = OS.get_system_time_msecs()
	for i in range(Global.generations[Global.generations.size()-1].end_idx):
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
