extends Node2D

@onready var DialogueLabel: RichTextLabel = $CanvasLayer/HBoxContainer/VBoxContainer/RichTextLabel
@onready var SpeakerSprite: Sprite2D = $CanvasLayer/HBoxContainer/speakerparent/Sprite2D

var dialogue: Array[DE]
var current_dialogue_item: int = 0
var next_item: bool = true

var player_node: CharacterBody2D


func _ready() -> void:
	visible = false
	$"CanvasLayer/HBoxContainer/VBoxContainer/button container".visible = false
	
	for i in get_tree().get_nodes_in_group("player"):
		player_node = i
		
		
func _process(_delta: float) -> void:
	if current_dialogue_item == dialogue.size():
		if !player_node:
			for i in get_tree().get_nodes_in_group("player"):
				player_node = i
			return
		player_node.can_move = true
		queue_free()
		return
		
	if next_item:
		next_item = false
		var i = dialogue[current_dialogue_item]

		if i is dialoguefunction:
			if i.hide_dialogue_box:
				visible = false
			else:
				visible = true
			_function_resource(i)

		elif i is dialoguechoice:
			visible = true
			_choice_resource(i)

		elif i is DialogueText:
			visible = true
			_text_resource(i)

		else:
			printerr("You accidentally added a DE resource!")
			current_dialogue_item += 1
			next_item = true

func _function_resource(i: dialoguefunction) -> void:
	var target_node = get_node(i.target_path)
	if target_node.has_method(i.function_name):
		if i.function_arguments.size() == 0:
			target_node.call(i.function_name)
		else:
			target_node.callv(i.function_name, i.function_arguments)
			
	if i.wait_for_signal_to_continue:
		var signal_name = i.wait_for_signal_to_continue
		if target_node.has_signal(signal_name):
			var signal_state = { "done": false }
			var callable = func(_args): signal_state.done = true
			target_node.connect(signal_name, callable, CONNECT_ONE_SHOT)
			while not signal_state.done:
				await get_tree().process_frame
	current_dialogue_item += 1
	next_item = true

func _choice_resource(i: dialoguechoice) -> void:
	#set speaker name here as well!
	DialogueLabel.text = i.text
	DialogueLabel.visible_characters = -1
	if i.speaker_img:
		$CanvasLayer/HBoxContainer/speakerparent.visible = true
		SpeakerSprite.texture = i.speaker_img
		SpeakerSprite.hframes = i.speaker_img_Hframes
		SpeakerSprite.frame = min(i.speaker_img_select_frame, i.speaker_img_Hframes-1)
	else:
		$CanvasLayer/HBoxContainer/speakerparent.visible = false
	$"CanvasLayer/HBoxContainer/VBoxContainer/button container".visible = true

func _text_resource(i: DialogueText) -> void:
	#set speaker name here as well!
	$AudioStreamPlayer.stream = i.text_sound
	$AudioStreamPlayer.volume_db = i.text_volume_db
	var camera: Camera2D = get_viewport().get_camera_2d()
	if camera and i.camera_position != Vector2(999.999, 999.999):
		var camera_tween: Tween = create_tween().set_trans(Tween.TRANS_SINE)
		camera_tween.tween_property(camera, "global_position", i.camera_position, i.camera_transition_time)

	if !i.speaker_img:
		$CanvasLayer/HBoxContainer/speakerparent.visible = false
	else:
		$CanvasLayer/HBoxContainer/speakerparent.visible = true
		SpeakerSprite.texture = i.speaker_img
		SpeakerSprite.hframes = i.speaker_img_Hframes
		SpeakerSprite.frame = 0
		
	DialogueLabel.visible_characters = 0
	DialogueLabel.text = i.text
	var text_without_square_brackets: String = _text_without_square_brackets(i.text)
	var total_characters: int = text_without_square_brackets.length()
	var character_timer: float = 0.0
	while DialogueLabel.visible_characters < total_characters:
		if Input.is_action_just_pressed("jump_text"):
			DialogueLabel.visible_characters = total_characters
			break

		character_timer += get_process_delta_time()
		if character_timer >= (1.0 / i.text_speed) or text_without_square_brackets[DialogueLabel.visible_characters] == "":
			var character: String = text_without_square_brackets[DialogueLabel.visible_characters]
			DialogueLabel.visible_characters += 1
			if character != " ":
				$AudioStreamPlayer.pitch_scale = randf_range(i.text_volume_pitch_min, i.text_volume_pitch_max)
				$AudioStreamPlayer.play()
				if i.speaker_img_Hframes != 1:
					if SpeakerSprite.frame < i.speaker_img_Hframes - 1:
						SpeakerSprite.frame += 1
					else:
						SpeakerSprite.frame = 0
			character_timer = 0.0
		await get_tree().process_frame
	SpeakerSprite.frame = min(i.speaker_img_rest_frame, i.speaker_img_Hframes-1)

	while true:
		await get_tree().process_frame
		if DialogueLabel.visible_characters == total_characters:
			if Input.is_action_just_pressed("interact"):
				current_dialogue_item += 1
				next_item = true
				
			
func _text_without_square_brackets(text: String) -> String:
	var result: String = ""
	var inside_bracket: bool = false

	for i in text:
		if i == "[":
			inside_bracket = true
			continue

		if i == "]":
			inside_bracket = false
			continue

		if !inside_bracket:
			result += i

	return result
		
		
