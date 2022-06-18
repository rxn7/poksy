extends Node

const GENERATION_1_START: int = 1
const GENERATION_1_END: int = 151
const GENERATION_2_START: int = 152
const GENERATION_2_END: int = 251
const DEV_POKEMONS_DIRECTORY: String = "/home/rxn/dev/godot/poksy/Pokemons"

var background_textures: Array
var random: Random
var quiz_manager: QuizManager

func _ready() -> void:
	random = Random.new()
	random.init()
	init_background_textures()

func init_background_textures() -> void:
	var dir: Directory = Directory.new()

	if dir.open("res://Textures/Backgrounds") != OK:
		return

	if dir.list_dir_begin(true, true) != OK:
		return

	var file: String = dir.get_next()
	while file != "":
		var ext: String = file.get_extension()
		if ext == "png" || ext == "jpg":
			background_textures.push_back(load("res://Textures/Backgrounds/%s" % file))

		file = dir.get_next()

	dir.list_dir_end()


func get_random_background_texture() -> Texture:
	return background_textures[Global.random.rand_i(0, background_textures.size()-1)] as Texture
