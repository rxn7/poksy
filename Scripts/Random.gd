extends Node
class_name Random

var rng: RandomNumberGenerator;

func init() -> void:
	rng = RandomNumberGenerator.new();
	rng.randomize();

func rand_f(from: float, to: float) -> float:
	return rng.randf() * (from - to) + from;

func rand_i(from: int, to: int) -> int:
	return rng.randi_range(from, to);

func rand_i_arr(from: int, to: int, count: int) -> Array:
	var arr: Array = [];

	for _i in range(count):
		var rnd: int = rand_i(from, to)

		while(arr.has(rnd)):
			rnd = rand_i(from, to)

		arr.push_back(rnd);

	return arr

func rand_i_arr_except(from: int, to: int, count: int, except: int) -> Array:
	var arr: Array = [];

	for _i in range(count):
		var rnd: int = rand_i(from, to)

		while(arr.has(rnd) || rnd == except):
			rnd = rand_i(from, to)

		arr.push_back(rnd);

	return arr
