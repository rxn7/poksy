extends Node
class_name PokeApi

var http_req: HTTPRequest

func _ready() -> void:
	http_req = HTTPRequest.new()
	http_req.connect("request_completed", self, "on_request_completed")
	add_child(http_req)

func request_pokemon(id: int) -> void:
	var url: String = "https://pokeapi.co/api/v2/pokemon/%s" % [str(id)]
	print(url)
	var result: int = http_req.request(url)
	if result != OK:
		printerr("Failed to request pokemon %s from %s" % [name, url])

func on_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray):
	var json: JSONParseResult = JSON.parse(body.get_string_from_utf8())
	print(json.result["species"]["name"])
