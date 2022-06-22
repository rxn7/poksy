extends Control

onready var max_lives_texture: TextureRect = get_node("MaxLivesTexture")
onready var current_lives_texture: TextureRect = get_node("CurrentLivesTexture")

func on_lives_changed(lives: int, max_lives: int) -> void:
	current_lives_texture.rect_size.x = 16 * lives
	max_lives_texture.rect_size.x = 16 * max_lives
