extends Node

onready var highest_score_label: Label = get_node("PBText")

func _ready() -> void:
	highest_score_label.text = "Rekord: %s" % Global.load_highest_score()

func on_play_button_pressed() -> void:
	get_tree().change_scene("res://Scenes/Game.tscn")
