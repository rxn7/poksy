extends Node

const DEV_POKEMONS_DIRECTORY: String = "/home/rxn/dev/godot/poksy/Pokemons"

var gen_1: Generation = Generation.new(1, 150)
var gen_2: Generation = Generation.new(152, 251)
var gen_3: Generation = Generation.new(252, 386)
var gen_4: Generation = Generation.new(387, 493)
var generations: Array = [
	gen_1,
	gen_2,
	gen_3,
	gen_4
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
