extends DE
class_name dialoguechoice

@export var speaker_img: Texture #img do personagem falando
@export var speaker_img_Hframes: int = 1 #quantos quadros tem a img do personagem falando
@export var speaker_img_select_frame: int = 0 #forca a exibir um quadro dps de terminar de falar

@export_multiline var text: String

@export var choice_text: Array[String] #texto exibido nos botoes
@export var choice_function_call: Array[dialoguefunction] #funcao q coresponde a esse botao
