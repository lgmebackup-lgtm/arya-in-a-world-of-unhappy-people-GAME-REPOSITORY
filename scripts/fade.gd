extends CanvasLayer

@onready var animation: AnimationPlayer = $AnimationPlayer
@export var scene: String
@export var local = Vector2()
var player
var to_local = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	print(player)

func fade_to_scene(new_scene: String) -> void:
	scene = new_scene
	animation.play("fade")


func change_scene() -> void:
	if to_local:
		player = get_tree().get_first_node_in_group("player")

		if player != null:
			player.global_position = local
			to_local = false
			player.global_position = local
			to_local = false
	else:
		get_tree().change_scene_to_file(scene)
	

func fade_to_local(new_local: Vector2) -> void:
	local = Vector2(new_local)
	to_local = true
	animation.play("fade_local")
	
