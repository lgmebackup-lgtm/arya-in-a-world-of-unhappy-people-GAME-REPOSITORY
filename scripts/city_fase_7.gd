extends TileMapLayer


var flor_murcha = true

@onready var flor_dialogue: CollisionShape2D = $"flor dialogue/CollisionShape2D"
@onready var flor: Sprite2D = $flor
@onready var rain: CPUParticles2D = $rain
@onready var snow: CPUParticles2D = $snow
var quebra_gelo = true
@onready var gelo: TileMapLayer = $gelo2
@onready var gelo_collision: CollisionShape2D = $gelo2/StaticBody2D/CollisionShape2D
@onready var gelo_partcles: CPUParticles2D = $gelo_partcles
var can_talk = false
@onready var rain_audio: AudioStreamPlayer = $"rain audio"

func _physics_process(delta: float) -> void:
	
	if can_talk:
		flor_dialogue.disabled = false
	else:
		flor_dialogue.disabled = true

func on_rain():
	if not rain_audio.playing:
		rain_audio.play()
	rain.emitting = true
	snow.emitting = false
	crescer_flor()
	quebrar_gelo()


func on_snow():
	if rain_audio.playing:
		rain_audio.stop()
	snow.emitting = true
	rain.emitting = false
	restaurar_gelo()

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
	can_talk = true
	
func _on_agua_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		FadeReload.fade_to_scene()
