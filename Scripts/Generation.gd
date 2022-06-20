class_name Generation

var start_idx: int
var end_idx: int

func _init(_start_idx: int, _end_idx: int) -> void:
	start_idx = _start_idx
	end_idx = _end_idx

func get_random_idx() -> int:
	return Global.random.rand_i(start_idx, end_idx)
