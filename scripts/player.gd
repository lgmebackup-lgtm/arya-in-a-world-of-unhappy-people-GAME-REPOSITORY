extends CharacterBody2D




var speed = 200
var jump_speed = -200
var healt = 3
var in_floor = true
var squash = false
var squash_tween: Tween
var flash_tween: Tween
var knockback_velocity: Vector2
var left = false
var coyotetime_actived: bool = false

@export var can_move = true

@onready var animation: Sprite2D = $Sprite2D
@onready var rain: CPUParticles2D = $"../rain"
@onready var snow: CPUParticles2D = $"../snow"
@onready var camera: Camera2D = $Camera2D
@onready var healt_1: Sprite2D = $CanvasLayer/healt1
@onready var healt_2: Sprite2D = $CanvasLayer/healt2
@onready var healt_3: Sprite2D = $CanvasLayer/healt3
@onready var partcles_healt_1: CPUParticles2D = $CanvasLayer/partcles_healt1
@onready var partcles_healt_2: CPUParticles2D = $CanvasLayer/partcles_healt2
@onready var partcles_healt_3: CPUParticles2D = $CanvasLayer/partcles_healt3
@onready var coyotetimer: Timer = $coyotetimer
@onready var pulo_sound: AudioStreamPlayer = $"pulo sound"
@onready var hit_sound: AudioStreamPlayer = $"hit sound"
@onready var muzzle: Marker2D = $muzzle
@onready var muzzle_key: Marker2D = $muzzle_key

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		squash = false
		velocity += get_gravity() * delta
		if not coyotetime_actived:
			coyotetimer.start()
			coyotetime_actived = true
	else:
		if coyotetime_actived:
			coyotetime_actived = false
			coyotetimer.stop()
		
	if is_on_floor() and not squash:
		squash = true
		squash_back()
		
	
	if not can_move or healt <= 0:
		velocity.x = 0.0
	else:
	
		if knockback_velocity != Vector2.ZERO:
			velocity = knockback_velocity
		else:
			if Input.is_action_just_pressed("ui_accept") and (not coyotetimer.is_stopped() or is_on_floor()):
				squash_jump()
				pulo_sound.play()
				velocity.y = jump_speed
				coyotetimer.stop()
				coyotetime_actived = true
				
			if Input.is_action_just_pressed("reload"):
				can_move = false
				FadeReload.fade_to_scene()
				
			var direction := Input.get_axis("ui_left", "ui_right")
			if direction:
				velocity.x = direction * speed
			else:
				velocity.x = move_toward(velocity.x, 0, speed)
			
		
	fliph()
	move_and_slide()

func fliph():
	if not knockback_velocity:
		if velocity.x > 0:
			animation.flip_h = true
			muzzle.position.x = -4
			if not left:
				squash_flip()
				left = true

		if velocity.x < 0:
			animation.flip_h = false
			muzzle.position.x = 4
			if left:
				squash_flip()
				left = false

func _new_tween() -> Tween:
	if squash_tween and squash_tween.is_valid():
		squash_tween.kill()
	squash_tween = create_tween()
	return squash_tween
	
func squash_jump() -> void:
	animation.scale = Vector2(0.5, 1.5)
	var tween = create_tween()
	tween.tween_property(animation, "scale", Vector2.ONE, 0.25)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

func squash_back() -> void:
	animation.scale = Vector2(1.5, 0.5)
	_new_tween().tween_property(animation, "scale", Vector2.ONE, 0.25)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

func squash_elastic() -> void:
	animation.scale = Vector2(1.7, 0.3)
	_new_tween().tween_property(animation, "scale", Vector2.ONE, 0.5)\
		.set_trans(Tween.TRANS_ELASTIC)\
		.set_ease(Tween.EASE_OUT)
	hit_flash()

func squash_flip() -> void:
	animation.scale = Vector2(1.3, 0.7)
	_new_tween().tween_property(animation, "scale", Vector2.ONE, 0.25)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

func hit_flash() -> void:
	if flash_tween and flash_tween.is_valid():
		flash_tween.kill()
	animation.modulate = Color(3, 3, 3)
	flash_tween = create_tween()
	flash_tween.tween_property(animation, "modulate", Color.WHITE, 0.15)

func apply_knockback(direction, knockback_force):
	if healt > 0:
		knockback_velocity = direction * knockback_force
		
		await get_tree().create_timer(0.1).timeout
		
		knockback_velocity = Vector2.ZERO

func damage(damage: int):
	if healt > 0:
		healt -= damage
		squash_elastic()
		hit_flash()
		camera.screen_shake()
		hit_sound.play()
		update_healt()

		
	if healt <= 0:
		await get_tree().create_timer(0.3).timeout
		FadeReload.fade_to_scene()
		
func update_healt():
	healt_1.visible = healt >= 3
	healt_2.visible = healt >= 2
	healt_3.visible = healt >= 1

	partcles_healt_1.emitting = healt == 2
	partcles_healt_2.emitting = healt == 1
	partcles_healt_3.emitting = healt == 0
		
		
