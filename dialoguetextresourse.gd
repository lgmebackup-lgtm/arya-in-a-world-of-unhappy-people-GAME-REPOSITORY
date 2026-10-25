extends DE
class_name DialogueText

@export var speaker_img: Texture #img do personagem falando
@export var speaker_img_Hframes: int = 1 #quantos quadros tem a img do personagem falando
@export var speaker_img_rest_frame: int = 0 #forca a exibir um quadro dps de terminar de falar

@export_multiline var text: String #dialogo sendo falado
@export_range(0.1, 30.0, 0.1) var text_speed: float = 1.0 #velocidade de escrita

@export var text_sound: AudioStream #audio reproduzido por caractere
@export var text_volume_db: int #volume do audio
@export var text_volume_pitch_min: float = 0.85 #pitch minimo
@export var text_volume_pitch_max: float = 1.15 #pitch maximo

@export var camera_position: Vector2 = Vector2(999.999, 999.999) #posicao pra onde mover a camera
@export_range(0.05, 10.0, 0.05) var camera_transition_time: float = 1.0 #tempo pra camera chegar na posicao 
