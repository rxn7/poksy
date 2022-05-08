extends Node

var http_req: HTTPRequest
var requests: Array
var is_busy: bool
var start_time: int

func _ready():
	is_busy = false
	requests = Array()

	http_req = HTTPRequest.new()
	http_req.connect("request_completed", self, "on_request_completed")
	add_child(http_req)

	start_time = OS.get_system_time_msecs()
	preload_generation(1, 1, 151)
	preload_generation(2, 152, 251)

func preload_generation(gen: int, from: int, to: int) -> void:
	var dir: Directory = Directory.new()
	if dir.open("/home/rxn/dev/godot/Pokex/Pokemons") != OK:
		printerr("Failed to open pokemons root directory for generation %s" % gen)
		return

	if dir.dir_exists(str(gen)):
		if dir.remove(str(gen))	!= OK:
			printerr("Failed to remove generation directory")
			return

	if dir.make_dir(str(gen)) != OK:
		printerr("Failed to make directory for generation %s" % gen)
		return

	print("Preloading generation %s" % gen)
	for i in range(from, to+1):
		request_pokemon(i)

func on_pokemon_loaded(data: PokemonData) -> void:
	print("=================")
	print(data.name)
	print(data.spriteUrl)
	print(data.type)

func request_pokemon(_id: int) -> void:
	requests.push_back(_id)

func _process(_dt: float) -> void:
	if !is_busy:
		if requests.empty():
			print("Preloading finished, time elapsed: %ss" % ((OS.get_system_time_msecs() - start_time) / 1000.0))
			get_tree().quit()
			return

		var id: int = requests.pop_front()
		var url: String = "https://pokeapi.co/api/v2/pokemon/%s" % id
		if http_req.request(url, [], false, HTTPClient.METHOD_GET) != OK: 
			printerr("Failed to request pokemon from %s" % url)
		else:
			is_busy = true

func on_request_completed(_result: int, _response_code: int, _headers: PoolStringArray, _body: PoolByteArray) -> void:
	var json: JSONParseResult = JSON.parse(_body.get_string_from_utf8())
	var data: PokemonData = PokemonData.new()
	data.id = json.result["id"]
	data.name = json.result["species"]["name"]
	data.spriteUrl = json.result["sprites"]["front_default"]
	if data.id < 152: data.generation = 1
	elif data.id < 252: data.generation = 2
	for type in json.result["types"]:
		data.type |= PokemonData.get_type_from_string(type["type"]["name"])
	on_load(data)
	is_busy = false

func on_load(data: PokemonData) -> void:
	var result: int = ResourceSaver.save("/home/rxn/dev/godot/Pokex/Pokemons/%s/%s.tres" % [data.generation, data.id], data)
	if result != OK: 
		printerr("Failed to save preloaded pokemon: %s#%s^%s, result: '%s'" % [data.name, data.id, data.generation, result])
	else:
		print("Successfully saved preloaded pokemon: %s#%s^%s" % [data.name, data.id, data.generation])
