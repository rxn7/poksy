extends Node

const GENERATION_1_START: int = 1
const GENERATION_1_END: int = 151
const GENERATION_2_START: int = 152
const GENERATION_2_END: int = 251
const GENERATION_COUNT: int = 2
const DEV_POKEMONS_DIRECTORY: String = "/home/rxn/dev/godot/poksy/Pokemons"

var background_imgs: Array = [
	preload("res://Textures/Backgrounds/1.png"),
	preload("res://Textures/Backgrounds/2.jpg")
]

var random: Random
var game_manager: GameManager
onready var music_player: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready() -> void:
	random = Random.new()
	random.init()
	music_player.stream = preload("res://Sounds/music.mp3")
	music_player.bus = "Music"
	music_player.play()
	add_child(music_player)


func get_random_background_texture() -> Texture:
	return background_imgs[Global.random.rand_i(0, background_imgs.size()-1)]
