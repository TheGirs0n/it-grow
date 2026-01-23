extends Node
class_name GameManager

@export var max_attempts : int = 5

var current_attempts : int = 0
var start_attempts : int = 0 

func _ready() -> void:
	GlobalContext.game_manager_instance = self
	
	current_attempts = start_attempts
	
func _exit_tree() -> void:
	GlobalContext.game_manager_instance = null

func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		pause_game()

func continue_game():
	pass

func pause_game():
	GlobalContext.main_ui_instance.open_pause()
	
func increase_current_attempts():
	if current_attempts < max_attempts:
		current_attempts += 1
	else:
		pass
		# вызываем мини-игру
	
func decrease_current_attempts():
	current_attempts -= 1
