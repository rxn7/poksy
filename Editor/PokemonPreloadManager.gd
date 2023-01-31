extends Node
class_name PreloadManager

var start_time: int
var queried_ids: Array

func _ready() -> void:
	var res_dir: Directory = Directory.new()
	assert(res_dir.open("res://") == OK)
	assert(res_dir.make_dir_recursive("Pokemons/Sprites") == OK)
	assert(res_dir.make_dir_recursive("Pokemons/Data") == OK)

	print("Preloading Pokemons...")
	start_time = OS.get_system_time_msecs()
	for i in range(1, Global.generations[Global.generations.size()-1].end_idx+1):
		request_pokemon(i)

func _process(_dt: float) -> void:
	while (get_child_count()*2) < IP.RESOLVER_MAX_QUERIES && queried_ids.size() > 0:
		var id: int = queried_ids.pop_front()
		add_preloader(id)
	
	if(queried_ids.size() == 0 && get_child_count() == 0):
		print("Pokemons have been preloaded, total time: ", OS.get_system_time_msecs() - start_time, "ms")
		get_tree().quit()

func request_pokemon(id: int) -> void:
	queried_ids.push_back(id)

func add_preloader(id: int) -> void:
	var preloader: PokemonPreloader = PokemonPreloader.new(id)
	add_child(preloader)
