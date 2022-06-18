extends Node
class_name Preloader

var id: int = 0
var data_http_req: HTTPRequest
var sprite_http_req: HTTPRequest

func _init(_id: int = 0) -> void:
	id = _id

func _ready() -> void:
	data_http_req = HTTPRequest.new()
	data_http_req.connect("request_completed", self, "on_data_received")
	add_child(data_http_req)

	sprite_http_req = HTTPRequest.new()
	sprite_http_req.connect("request_completed", self, "on_sprite_received")
	add_child(sprite_http_req)

	var url: String = "https://pokeapi.co/api/v2/pokemon/%s" % id
	if data_http_req.request(url, [], false, HTTPClient.METHOD_GET) != OK: 
		printerr("Failed to request pokemon from %s" % url)
		queue_free()

func on_data_received(_result: int, _response_code: int, _headers: PoolStringArray, _body: PoolByteArray) -> void:
	if _response_code != 200:
		printerr("Failed to request data from PokeAPI, response was: %s" % _response_code)
		queue_free()
		return

	var json: JSONParseResult = JSON.parse(_body.get_string_from_utf8())
	var data: PokemonData = PokemonData.new()

	data.id = json.result["id"]
	data.name = json.result["species"]["name"]

	if data.id <= Global.GENERATION_1_END:
		data.generation = 1

	elif data.id <= Global.GENERATION_2_END:
		data.generation = 2

	else:
		printerr("Received pokemon from unsupported generation, ID: %s", data.id);
		return;

	for type in json.result["types"]:
		data.types.push_back(type["type"]["name"]);
	
	# Download the sprite
	var sprite_url: String = json.result["sprites"]["front_default"]
	sprite_http_req.request(sprite_url, [], false, HTTPClient.METHOD_GET)

	on_load(data)

func on_sprite_received(_result: int, _response_code: int, _headers: PoolStringArray, body: PoolByteArray) -> void:
	var img: Image = Image.new()
	if img.load_png_from_buffer(body) != OK:
		printerr("Failed to load image of ID: %s" % id)

	if img.save_png("%s/Sprites/%s.png" % [Global.DEV_POKEMONS_DIRECTORY, id]) != OK:
		printerr("Failed to save image of ID: %s" % id)
	
	queue_free()

func on_load(data: PokemonData) -> void:
	var result: int = ResourceSaver.save("%s/Data/%s.tres" % [Global.DEV_POKEMONS_DIRECTORY, data.id], data)
	if result != OK: 
		printerr("Failed to save preloaded pokemon: %s#%s^%s, result: '%s'" % [data.name, data.id, data.generation, result])
	else:
		print("Successfully saved preloaded pokemon: %s#%s^%s" % [data.name, data.id, data.generation])
