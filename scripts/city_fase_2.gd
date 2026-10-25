extends TileMapLayer

@onready var rain: CPUParticles2D = $rain
@onready var snow: CPUParticles2D = $snow
@onready var gelo_collision: CollisionShape2D = $gelo2/StaticBody2D/CollisionShape2D
@onready var gelo: TileMapLayer = $gelo2
var quebra_gelo = false
@onready var gelo_partcles: CPUParticles2D = $gelo_partcles
@onready var rain_audio: AudioStreamPlayer = $"rain audio"


func on_rain():
	rain.emitting = true
	snow.emitting = false
	quebrar_gelo()
	if not rain_audio.playing:
		rain_audio.play()


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
