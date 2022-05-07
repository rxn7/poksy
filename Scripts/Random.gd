extends Node
class_name Random

var rng: RandomNumberGenerator;

func _ready() -> void:
	rng = RandomNumberGenerator.new();
	rng.randomize();

func f(from: float, to: float) -> float:
	return rng.randf() * (from - to) + from;

func i(from: int, to: int) -> int:
	return rng.randi_range(from, to);
