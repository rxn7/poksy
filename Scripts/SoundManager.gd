extends Node

const POOL_SIZE = 8

var available: Array = []
var queue: Array = []

func _ready() -> void:
	for i in range(POOL_SIZE):
		var p: AudioStreamPlayer = AudioStreamPlayer.new()
		add_child(p)
		available.push_back(p)
		p.connect("finished", self, "on_player_finished", [p])

func on_player_finished(player: AudioStreamPlayer) -> void:
	available.push_back(player)

func play(stream: AudioStream, pitch: float = 1.0) -> void:
	queue.append(Sound.new(stream, pitch))

func _process(_delta: float) -> void:
	if not queue.empty() and not available.empty():
		var p: AudioStreamPlayer = available.pop_front()
		var s: Sound = queue.pop_front()
		p.stream = s.stream
		p.pitch_scale = s.pitch
		p.play()
