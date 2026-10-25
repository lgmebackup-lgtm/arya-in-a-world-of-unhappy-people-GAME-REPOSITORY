extends TileMapLayer




@onready var rain: CPUParticles2D = $rain
@onready var snow: CPUParticles2D = $snow
var ta_dentro = false
@export var player: CharacterBody2D
@onready var rain_audio: AudioStreamPlayer = $"rain audio"
@onready var agua: CPUParticles2D = $agua
@onready var dialogue_area: CollisionShape2D = $pessoa/CollisionShape2D
@onready var animation: AnimationPlayer = $AnimationPlayer
var fire_on = true
@onready var fire_collision: CollisionShape2D = $"fire collision/CollisionShape2D"
@onready var fire_hitbox: CollisionShape2D = $"fire hitbox/CollisionShape2D"
@onready var fire: GPUParticles2D = $"fire hitbox/fire"

func _process(delta: float) -> void:
	
	
	if not fire_on:
		fire_collision.disabled = true
		fire_hitbox.disabled = true

func on_rain():
	if not rain_audio.playing:
		rain_audio.play()
	rain.emitting = true
	snow.emitting = false
	await get_tree().create_timer(0.5).timeout
	agua.emitting = true
	await get_tree().create_timer(1.0).timeout
	fire.emitting = false
	fire_on = false

	

func on_snow():
	if agua.emitting:
		animation.play("gelo")
	if rain_audio.playing:
		rain_audio.stop()
	snow.emitting = true
	rain.emitting = false
	agua.emitting = false
	
	
	 

func apagar_dialogo():
	await get_tree().create_timer(0.2).timeout
	dialogue_area.queue_free()
	
func _on_fire_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and fire_on:
		body.damage(1)
		var knockback_direction = global_position.direction_to(body.global_position)
		knockback_direction.y = 0
		body.apply_knockback(knockback_direction, 300)
