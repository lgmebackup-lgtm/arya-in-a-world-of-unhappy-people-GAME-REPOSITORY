extends StaticBody2D

@export var chave: Area2D
var can_go = true
@onready var animation: AnimationPlayer = $AnimationPlayer


func _on_area_2d_body_entered(body: Node2D) -> void:
	if chave == null:
		return
		
	if body.is_in_group("player") and chave.pegou and can_go:
		chave.go_to_door()
		await get_tree().create_timer(0.30).timeout
		#chave.barulinho.play()
		animation.play("abrir")
		can_go = false
		
