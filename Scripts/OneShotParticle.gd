extends CPUParticles2D

func _ready():
	 emitting = true
	 position = get_viewport_rect().size / 2

func _physics_process(_delta: float):
	if !emitting:
		queue_free()
