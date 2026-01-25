extends Node
class_name GameManager

@export_group("Balance")
@export var max_attempts : int = 4

@export_group("Timer")
@export var day_timer : Timer

var max_day : int = 5
var start_day : int = 1
var current_day : int = 1

var current_attempts : int = 0
var start_attempts : int = 4 

func _ready() -> void:
	GlobalContext.game_manager_instance = self
	first_entry()
	
func _exit_tree() -> void:
	GlobalContext.game_manager_instance = null

func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		pause_game()
	
	GlobalContext.main_ui_instance.day_counter_ui.set_day_counter_number(day_timer.time_left)
	
func first_entry():
	current_attempts = start_attempts
	current_day = start_day
	
	var plant = PlantResourceFabric.get_first()
	
	day_timer.start()
	GlobalContext.main_ui_instance.spawn_plant_on_new_day(plant)
	GlobalContext.main_ui_instance.day_counter_ui.set_day_counter_text(current_day)
	GlobalContext.main_ui_instance.day_counter_ui.set_day_counter_number(day_timer.time_left)

func new_day_parameters():
	var new_plant = PlantResourceFabric.get_random_plant_resource()
	
	day_timer.start()
	GlobalContext.main_ui_instance.spawn_plant_on_new_day(new_plant)
	GlobalContext.main_ui_instance.day_counter_ui.set_day_counter_text(current_day)
	GlobalContext.main_ui_instance.day_counter_ui.set_day_counter_number(day_timer.time_left)

func continue_game():
	get_tree().paused = false

func pause_game():
	get_tree().paused = true
	GlobalContext.main_ui_instance.open_pause()
	
func increase_current_attempts():
	current_attempts += 1
	GlobalContext.main_ui_instance.attempts_ui.set_attempt_texture(current_attempts)
	
	
func decrease_current_attempts():
	if current_attempts > 0:
		current_attempts -= 1
		GlobalContext.main_ui_instance.attempts_ui.set_attempt_texture(current_attempts)
	else:
		get_tree().paused = true
		GlobalContext.main_ui_instance.open_minigame()

func day_timer_end() -> void:
	if current_day < max_day:
		current_day += 1
		GlobalContext.main_ui_instance.open_day_switcher(current_day)
		print(current_day)
	else:
		GlobalContext.main_ui_instance.open_victory_screen()
