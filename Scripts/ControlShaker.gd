extends Control
class_name ControlShaker

onready var initial_position = rect_position
var intensity: float = 0.0
var duration: float = 0.0
var timer: float = 0.0
var shake_position: Vector2 = Vector2.ZERO

func shake(_intensity: float, _duration: float) -> void:
	if _intensity > intensity && _duration > duration:
		intensity = _intensity
		duration = _duration
		timer = 0.0

func stop() -> void:
	intensity = 0.0
	duration = 0.0
	timer = 0.0

func _process(delta: float) -> void:
	if timer >= duration:
		intensity = 0.0
		duration = 0.0
	else:
		timer += delta

	var x: float = Global.random.rand_i(-1, 1) * Global.random.rand_f(0.5, 1)
	var y: float = Global.random.rand_i(-1, 1) * Global.random.rand_f(0.5, 1)

	shake_position = shake_position.linear_interpolate(Vector2(x, y) * intensity, delta * 40)

	rect_position = shake_position + initial_position

