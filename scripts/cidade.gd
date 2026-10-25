extends TileMapLayer

@onready var rain: CPUParticles2D = $"fase 1/rain"
@onready var snow: CPUParticles2D = $"fase 1/snow"
@onready var fire: GPUParticles2D = $"fase 1/fire hitbox/fire"
@onready var fire_hitbox: CollisionShape2D = $"fase 1/fire hitbox/CollisionShape2D"
@onready var fire_collision: CollisionShape2D = $"fase 1/fire collision/CollisionShape2D"
var fire_on = true
@onready var rain_audio: AudioStreamPlayer = $AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	if not fire_on:
		fire_collision.disabled = true
		fire_hitbox.disabled = true


func rain_on():
	if not rain_audio.playing:
		rain_audio.play()
	snow.emitting = false
	rain.emitting = true
	await get_tree().create_timer(1.0).timeout
	fire.emitting = false
	fire_on = false

	

func snow_on():
	rain.emitting = false
	snow.emitting = true
	await get_tree().create_timer(1.0).timeout
	if rain_audio.playing:
		rain_audio.stop()


func _on_fire_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and fire_on:
		body.damage(1)
		var knockback_direction = global_position.direction_to(body.global_position)
		knockback_direction.y = 0
		body.apply_knockback(knockback_direction, 300)
