extends Node

onready var sprite_texture_rect: TextureRect = get_node("Sprite")
onready var name_label: Label = get_node("Name")
onready var type_label: Label = get_node("Type")

func _ready() -> void:
	set_pokemon_data(PokemonData.load_data(1))

func _input(_event: InputEvent) -> void: 
	if _event.is_pressed():
		set_pokemon_data(PokemonData.load_data(Global.random.i(1,251)))

func set_pokemon_data(data: PokemonData) -> void:
	if data == null:
		printerr("PokemonData is null")
		return

	sprite_texture_rect.texture = data.load_sprite()
	name_label.text = data.name
	type_label.text = data.get_types_translated();
