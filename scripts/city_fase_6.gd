extends TileMapLayer



@onready var rain: CPUParticles2D = $rain
@onready var snow: CPUParticles2D = $snow
@onready var roda: Sprite2D = $roda
@onready var agua: CPUParticles2D = $agua
@onready var ponte_animation: AnimationPlayer = $AnimationPlayer
@onready var pedra_hitbox: CollisionShape2D = $pedra/Area2D/CollisionShape2D
@onready var dialogue_area: CollisionShape2D = $DialogueArea2D/CollisionShape2D
@onready var dialogue_area2: CollisionShape2D = $DialogueArea2D2/CollisionShape2D
@onready var gelo_animation: AnimationPlayer = $AnimationPlayer2
var ta_dentro = false
var pegou = false
var quebrou = false
var ta_dentro_g = false
@onready var pedra: Sprite2D = $pedra
@export var player: CharacterBody2D
@onready var gelo_5: Sprite2D = $gelos/gelo5
@onready var gelo_6: Sprite2D = $gelos/gelo6
@onready var gelo_4: Sprite2D = $gelos/gelo4
@onready var collision_gelo: CollisionShape2D = $gelos/StaticBody2D/CollisionShape2D
@onready var gelo_partcles: CPUParticles2D = $gelos/gelo_partcles
@onready var rain_audio: AudioStreamPlayer = $"rain audio"


func _ready() -> void:
	pass



func _physics_process(delta: float) -> void:
	if agua.emitting:
		roda.rotate(0.08)
		
	if pegou:
		pedra.global_position = player.muzzle.global_position
	if quebrou:
		$"gelos/gelos interact/AnimatedSprite2D".visible = false
		
	if Input.is_action_just_pressed("interact") and ta_dentro and not pegou:
		pegou = true

	if Input.is_action_just_pressed("interact") and ta_dentro_g and not quebrou:
		gelo_5.visible = false
		gelo_6.visible = false
		gelo_4.visible = false
		collision_gelo.disabled = true
		quebrou = true
		pegou = false
		gelo_partcles.emitting = true
		pedra.queue_free()

func on_rain():
	if not rain_audio.playing:
		rain_audio.play()
	rain.emitting = true
	snow.emitting = false
	await get_tree().create_timer(0.5).timeout
	agua.emitting = true
	ponte_animation.play("ponte")

func on_snow():
	if rain_audio.playing:
		rain_audio.stop()
	snow.emitting = true
	rain.emitting = false
	agua.emitting = false

func apagar_dialogo():
	await get_tree().create_timer(0.2).timeout
	dialogue_area.queue_free()

func apagar_dialogo2():
	gelo_animation.play("gelo")
	dialogue_area2.queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.can_move = false
		body.rotation = 190
		await get_tree().create_timer(1.0).timeout
		body.rotation = 0
		pedra_hitbox.disabled = true
		dialogue_area.disabled = false


func _on_pedra_interact_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and snow.emitting and not pegou:
		ta_dentro = true
		$"pedra interact/AnimatedSprite2D".visible = true


func _on_pedra_interact_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and snow.emitting:
		ta_dentro = false
		$"pedra interact/AnimatedSprite2D".visible = false


func _on_gelos_interact_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and pegou and not quebrou:
		ta_dentro_g = true
		$"gelos/gelos interact/AnimatedSprite2D".visible = true


func _on_gelos_interact_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and pegou:
		ta_dentro_g = false
		$"gelos/gelos interact/AnimatedSprite2D".visible = false
