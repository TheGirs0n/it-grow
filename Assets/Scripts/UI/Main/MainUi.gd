extends CanvasLayer
class_name MainUI

@export_group("Main UI")
@export var care_box_ui : CareBoxUI
@export var find_box_ui : FindBoxUI
@export var pause_menu_ui : PauseMenuUI
@export var day_counter_ui : DayCounterUI
@export var attempts_ui : AttemptsUI

@export_group("Packed Scenes")
@export var plant_scene : PackedScene
@export var game_over_mini_game_ui : PackedScene
@export var day_switcher_ui : PackedScene
@export var victory_screen : PackedScene
@export var lose_screen : PackedScene

func _ready() -> void:
	GlobalContext.main_ui_instance = self
	
func _exit_tree() -> void:
	GlobalContext.main_ui_instance = null

func settings_scene_open():
	hide_pause()

func spawn_plant_on_new_day():
	pass

func open_day_switcher(current_day : int):
	var scene = day_switcher_ui.instantiate() as DaySwitcherUI
	scene.prepare_text(current_day)
	self.add_child(scene)

func open_minigame():
	var scene = game_over_mini_game_ui.instantiate() as GameOverMiniGameUI
	scene.prepare_mini_game()
	self.add_child(scene)

func open_victory_screen():
	var scene = victory_screen.instantiate() as VictoryScreen
	# статистику добавить
	get_tree().root.add_child(scene)
	GlobalContext.game_manager_instance.queue_free()

func open_lose_screen():
	var scene = lose_screen.instantiate() as LoseScreen
	get_tree().root.add_child(scene)
	GlobalContext.game_manager_instance.queue_free()

func open_pause():
	pause_menu_ui.show()
	
func hide_pause():
	pause_menu_ui.hide()
