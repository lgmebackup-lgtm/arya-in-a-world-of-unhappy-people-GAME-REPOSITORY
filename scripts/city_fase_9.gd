extends TileMapLayer
@onready var snow: CPUParticles2D = $snow
@export var player: CharacterBody2D
@onready var rain: CPUParticles2D = $rain

func feliz():
	snow.emitting = true
	rain.emitting = true
	player.can_move = false
	await get_tree().create_timer(0.1).timeout
	player.can_move = false
	await get_tree().create_timer(4.9).timeout
	Fade.fade_to_scene("res://scenes/end_game.tscn")
