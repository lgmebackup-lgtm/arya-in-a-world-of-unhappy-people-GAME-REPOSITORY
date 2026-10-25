extends CanvasLayer

@onready var animation: AnimationPlayer = $AnimationPlayer
@export var pd = true
var player

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")


	

func fade_to_scene():
	if pd:
		animation.play("fade")
		pd = false


func change_scene() -> void:
	get_tree().reload_current_scene()

	
	
	
