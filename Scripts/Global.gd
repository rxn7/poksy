extends Node

var random: Random

func _ready() -> void:
	random = Random.new()
	add_child(random)
