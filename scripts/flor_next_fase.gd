extends Area2D

@export var next_fase = ""



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Fade.fade_to_scene(next_fase)
		Musica.next_fase.play()
