extends Area2D

@export var porta: StaticBody2D
@export var player: CharacterBody2D
var pegou = false
var go_door = false
@onready var chave: Area2D = $"."
var tween: Tween
@onready var barulinho: AudioStreamPlayer = $AudioStreamPlayer
@onready var collision: CollisionShape2D = $CollisionShape2D


func _physics_process(delta: float) -> void:
	
	if pegou:
		_new_tween().tween_property(chave, "global_position", player.muzzle_key.global_position, 0.15)\
			.set_trans(Tween.TRANS_LINEAR)\
			.set_ease(Tween.EASE_OUT)
	if go_door:
		_new_tween().tween_property(chave, "global_position", porta.global_position, 0.15)\
			.set_trans(Tween.TRANS_LINEAR)\
			.set_ease(Tween.EASE_OUT)
		


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not pegou:
		pegou = true
		collision.disabled = true
		barulinho.play()

func _new_tween() -> Tween:
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	return tween
	
func go_to_door():
	pegou = false
	go_door = true
	await get_tree().create_timer(0.5).timeout
	queue_free()
	
