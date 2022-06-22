extends Node

const DEV_POKEMONS_DIRECTORY: String = "/home/rxn/dev/godot/poksy/Pokemons"
const SAVE_DATA_LOCATION: String = "user://poksy.save"

var generations: Array = [
	Generation.new(1, 150),
	Generation.new(152, 251),
	Generation.new(252, 386),
	Generation.new(387, 493)
]

var background_imgs: Array = [
	preload("res://Textures/Backgrounds/2.jpg")
]

var random: Random
var game_manager: GameManager
onready var music_player: AudioStreamPlayer = AudioStreamPlayer.new()

func get_random_generation() -> Generation:
	return generations[random.rand_i(0, generations.size()-1)]

func _ready() -> void:
	random = Random.new()
	random.init()
	music_player.stream = preload("res://Sounds/music.mp3")
	music_player.bus = "Music"
	music_player.play()
	add_child(music_player)


func get_random_background_texture() -> Texture:
	return background_imgs[Global.random.rand_i(0, background_imgs.size()-1)]

func save_highest_score(hs: int) -> void:
	var file: File = File.new()
	file.open(SAVE_DATA_LOCATION, File.WRITE)
	file.store_var(hs)
	file.close()

func load_highest_score() -> int:
	var file: File = File.new()
	var hs: int = 0

	if file.file_exists(SAVE_DATA_LOCATION):
		file.open(SAVE_DATA_LOCATION, File.READ)
		hs = file.get_var()
		file.close()

	return hs
