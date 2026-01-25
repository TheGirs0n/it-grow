extends CanvasLayer
class_name MainUI

@export_group("Main UI")
@export var day_counter_ui : DayCounterUI
@export var attempts_ui : AttemptsUI
@export var care_box_ui : CareBoxUI
@export var find_box_ui : FindBoxUI
@export var info_tooltip_ui : InfoTooltip
@export var find_box_circle_center : FindBoxCircleCenter
@export var plant_spawn_location : PlantSpawnLocation
@export var pause_menu_ui : PauseMenuUI

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

func spawn_plant_on_new_day(plant_scene : PlantTemplate):
	plant_spawn_location.set_plant_on_first_enable(plant_scene)

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

func show_tooltip(text_in_tooltip : String):
	info_tooltip_ui.change_text(text_in_tooltip)
	info_tooltip_ui.show_tooltip()

func hide_tooltip():
	info_tooltip_ui.hide_tooltip()

func open_find_box_center(new_plant_texture : CompressedTexture2D, new_effect_texture : CompressedTexture2D):
	find_box_circle_center.show_circle(new_plant_texture, new_effect_texture)

func open_pause():
	pause_menu_ui.show()
	
func hide_pause():
	pause_menu_ui.hide()
