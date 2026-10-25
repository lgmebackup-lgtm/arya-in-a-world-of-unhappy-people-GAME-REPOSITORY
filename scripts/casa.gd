extends TileMapLayer

@onready var player: CharacterBody2D = $player
var entrada_sala =  Vector2(576.0, 586.0)
@onready var camera: Camera2D = $player/Camera2D
var entrada_quarto = Vector2(705.0, 590.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Fade.fade_to_local(entrada_sala)
		await get_tree().create_timer(0.3).timeout
		camera.limit_bottom = 737
		camera.limit_top = 513
		camera.limit_left = 176
		camera.limit_right = 592
		camera.position_smoothing_enabled = false


func _on_voltar_pro_quarto_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Fade.fade_to_local(entrada_quarto)
		await get_tree().create_timer(0.3).timeout
		camera.limit_bottom = 672
		camera.limit_top = 496
		camera.limit_left = 688
		camera.limit_right = 992
		camera.position_smoothing_enabled = false


func _on_sair_pra_cidade_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Fade.fade_to_scene("res://scenes/cidade.tscn")
