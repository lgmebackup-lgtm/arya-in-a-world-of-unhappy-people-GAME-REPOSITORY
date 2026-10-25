extends DE
class_name dialoguefunction

@export var target_path: NodePath #no q tem a funcao que vai chamar
@export var function_name: String #nome da funcao q vai chamar
@export var function_arguments: Array #variaveis da funcao q vai chamar

@export var hide_dialogue_box: bool #ocultar a caixa de dialogo enquanto chamar a funcao
@export var wait_for_signal_to_continue: String = "" #espera chamar a funcao pra dps continuar
