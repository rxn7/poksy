extends TextureRect
class_name BackgroundTextureRect

func _ready() -> void:
	texture = Global.get_random_background_texture()
