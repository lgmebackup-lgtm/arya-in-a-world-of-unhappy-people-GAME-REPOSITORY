extends Control


@onready var button: Button = $Button
var squash_tween: Tween
var flash_tween: Tween
@onready var click: AudioStreamPlayer = $click

func _new_tween() -> Tween:
	if squash_tween and squash_tween.is_valid():
		squash_tween.kill()
	squash_tween = create_tween()
	return squash_tween

func squash_up() -> void:
	# Começa num tamanho ligeiramente comprimido ou maior (ex: 1.2 no X e 0.8 no Y)
	button.scale = Vector2(100, 100)
	
	# Anima para o tamanho normal ou para o efeito de squash desejado (ex: 1.0, 1.0)
	_new_tween().tween_property(button, "scale", Vector2(120, 120), 0.4)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_IN_OUT)
		
func squash_down() -> void:
	# Começa num tamanho ligeiramente comprimido ou maior (ex: 1.2 no X e 0.8 no Y)
	button.scale = Vector2(120, 120)
	
	# Anima para o tamanho normal ou para o efeito de squash desejado (ex: 1.0, 1.0)
	_new_tween().tween_property(button, "scale", Vector2(100, 100), 0.4)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_IN_OUT)

func _on_button_mouse_entered() -> void:
	squash_up()

func _on_button_mouse_exited() -> void:
	squash_down()



func _on_button_pressed() -> void:
	click.play()
	Fade.fade_to_scene("res://scenes/casa.tscn")
