extends Camera2D

@export var random_srength: float = 5.0
@export var shake_fade: float = 15.0

var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0

func _physics_process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		
		offset = random_offset()
	
	
func screen_shake():
	shake_strength = random_srength
	
func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
