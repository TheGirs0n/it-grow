extends Node
class_name GameManager

## Исправлено:
##   - first_entry() убран из _ready() → перенесён в конец setup()
##     Причина: в Godot дочерние _ready() вызываются раньше родительского MainScene._ready(),
##     поэтому emit new_day_started происходил до подписки MainUI → растение не появлялось.
##   - Добавлена подписка на EventBus.attempts_increase_requested

@export_group("Balance")
@export var max_attempts: int = 4

@export_group("Timer")
@export var day_timer: Timer

var max_day: int = 5
var start_day: int = 1
var current_day: int = 1

var current_attempts: int = 0
var start_attempts: int = 4

var plants_in_game: Dictionary

# Включается composition root'ом (MainScene) при первом запуске.
# В этом режиме таймер дня стартует на паузе — обучение снимает её сигналом tutorial_finished.
var tutorial_mode: bool = false

var _main_ui: MainUI


func setup(main_ui: MainUI) -> void:
	_main_ui = main_ui
	_wire_events()
	# FIX: first_entry перенесён сюда из _ready()
	# На момент вызова setup() MainUI уже подписана на EventBus → сигналы доходят
	first_entry()


func _wire_events() -> void:
	EventBus.day_switcher_close_requested.connect(_on_day_switcher_close)
	EventBus.game_manager_free_requested.connect(queue_free)
	EventBus.plant_registered.connect(add_plant)
	EventBus.plant_fully_grown.connect(set_plant_full)
	EventBus.plant_grow_failed.connect(decrease_current_attempts)
	# FIX: подписка на новый сигнал из мини-игры
	EventBus.attempts_increase_requested.connect(increase_current_attempts)
	# Обучение завершено — снимаем паузу таймера дня
	EventBus.tutorial_finished.connect(_on_tutorial_finished)


func _ready() -> void:
	GlobalAudio.play_main_theme()
	# FIX: first_entry() убран отсюда — перенесён в setup()


func _process(_delta: float) -> void:
	EventBus.day_timer_tick.emit(day_timer.time_left)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		pause_game()


func add_plant(new_plant: PlantTemplate) -> void:
	plants_in_game[new_plant] = false


func set_plant_full(plant_to_set: PlantTemplate) -> void:
	plants_in_game[plant_to_set] = true
	check_plants_grow()


func check_plants_grow() -> void:
	for plant in plants_in_game:
		if plants_in_game[plant] == false:
			return
	day_timer_end()


func first_entry() -> void:
	current_attempts = start_attempts
	current_day = start_day

	continue_game()
	PlantResourceFabric.reset_fabric()
	var plant: PlantTemplate = PlantResourceFabric.get_first()

	day_timer.start()
	# В режиме обучения замораживаем отсчёт — без давления времени на первом цветке
	if tutorial_mode:
		day_timer.paused = true
	EventBus.new_day_started.emit(current_day, plant)


func _on_tutorial_finished() -> void:
	day_timer.paused = false


func new_day_parameters() -> void:
	var new_plant = PlantResourceFabric.get_random_plant_resource()
	day_timer.start()
	EventBus.new_day_started.emit(current_day, new_plant)


func continue_game() -> void:
	get_tree().paused = false
	EventBus.game_continued.emit()


func pause_game() -> void:
	get_tree().paused = true
	EventBus.game_paused.emit()


func increase_current_attempts() -> void:
	current_attempts += 1
	EventBus.attempts_updated.emit(current_attempts)


func decrease_current_attempts() -> void:
	if current_attempts > 0:
		current_attempts -= 1
		EventBus.attempts_updated.emit(current_attempts)
	else:
		get_tree().paused = true
		EventBus.minigame_requested.emit()


func day_timer_end() -> void:
	if current_day < max_day:
		current_day += 1
		day_timer.paused = true
		_main_ui.open_day_switcher(current_day)
	else:
		EventBus.game_over_won.emit()


func _on_day_switcher_close() -> void:
	new_day_parameters()
	day_timer.paused = false
