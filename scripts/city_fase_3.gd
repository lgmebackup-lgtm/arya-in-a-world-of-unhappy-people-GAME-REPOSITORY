extends TileMapLayer

@onready var rain: CPUParticles2D = $rain
@onready var snow: CPUParticles2D = $snow
@onready var fire: GPUParticles2D = $"fire hitbox/fire"
@onready var fire_hitbox: CollisionShape2D = $"fire hitbox/CollisionShape2D"
@onready var fire_collision: CollisionShape2D = $"fire collision/CollisionShape2D"
@onready var gelo_collision: CollisionShape2D = $gelo2/StaticBody2D/CollisionShape2D
@onready var gelo: TileMapLayer = $gelo2
@onready var gelo_partcles: CPUParticles2D = $gelo_partcles
@onready var rain_audio: AudioStreamPlayer = $"rain audio"

var is_rain = false
var is_snow = true
var fire_on = true
var quebra_gelo = false
var can_go = true

func on_rain():
	if not rain_audio.playing:
		rain_audio.play()
	rain.emitting = true
	snow.emitting = false
	quebrar_gelo()
	await get_tree().create_timer(1.0).timeout
	fire.emitting = false
	fire_collision.disabled = true
	fire_hitbox.disabled = true
	fire_on = false

func on_snow():
	snow.emitting = true
	rain.emitting = false
	restaurar_gelo()
	if rain_audio.playing:
		rain_audio.stop()

func quebrar_gelo():
	if quebra_gelo:
		return
	quebra_gelo = true
	await get_tree().create_timer(0.2).timeout
	gelo_partcles.restart()
	gelo_collision.disabled = true
	gelo.visible = false

func restaurar_gelo():
	quebra_gelo = false
	gelo_collision.disabled = false
	gelo.visible = true

func _on_gelo_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.velocity.y > 0:
		quebrar_gelo()
		
func _on_agua_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		FadeReload.fade_to_scene()



			
			

func _on_fire_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and fire_on:
		body.damage(1)
		var knockback_direction = global_position.direction_to(body.global_position)
		knockback_direction.y = 0
		body.apply_knockback(knockback_direction, 300)
