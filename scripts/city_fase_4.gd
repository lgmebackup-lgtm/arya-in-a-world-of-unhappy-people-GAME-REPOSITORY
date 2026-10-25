extends TileMapLayer

var flor_murcha = true

@onready var flor_dialogue: CollisionShape2D = $"flor dialogue/CollisionShape2D"
@onready var flor: Sprite2D = $"flor dialogue/flor"
@onready var rain: CPUParticles2D = $rain
@onready var snow: CPUParticles2D = $snow
var quebra_gelo = true
@onready var gelo: TileMapLayer = $gelo2
@onready var gelo_collision: CollisionShape2D = $gelo2/StaticBody2D/CollisionShape2D
@onready var flor_murcha_dialogue: Area2D = $"flor murcha dialogue"
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

func crescer_flor():
	flor.frame = 0
	flor_murcha = false
	flor_dialogue.disabled = false
	
	

	
func apagar_dialogo():
	await get_tree().create_timer(0.2).timeout
	flor_murcha_dialogue.queue_free()
	
func _on_agua_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		FadeReload.fade_to_scene()
