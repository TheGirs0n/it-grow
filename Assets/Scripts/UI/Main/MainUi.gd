extends CanvasLayer
class_name MainUI

## Убраны: GlobalContext из _ready/_exit_tree
## Добавлен setup(game_manager) — composition root вызывает из MainScene
## Внутренние узлы связываются здесь, а не через GlobalContext

@export_group("Main UI")
@export var day_counter_ui: DayCounterUI
@export var attempts_ui: AttemptsUI
@export var care_box_ui: CareBoxUI
@export var find_box_ui: FindBoxUI
@export var info_tooltip_ui: InfoTooltip
@export var find_box_circle_center: FindBoxCircleCenter
@export var find_box_circle_center_add: FindBoxCircleCenterAdd
@export var plant_spawn_location: PlantSpawnLocation
@export var pause_menu_ui: PauseMenuUI

@export_group("Manuals")
@export var care_manual: CareManual
@export var find_manual: FindManual

@export_group("Packed Scenes")
@export var game_over_mini_game_ui: PackedScene
@export var day_switcher_ui: PackedScene
@export var victory_screen: PackedScene
@export var lose_screen: PackedScene


func setup(game_manager: GameManager) -> void:
	_wire_internal_ui()
	_wire_events()
	plant_spawn_location.setup(self)


func _wire_internal_ui() -> void:
	# Связываем CareBox и FindBox напрямую — оба дочерних, MainUI их знает
	care_box_ui.setup(find_box_ui)
	find_box_ui.setup(care_box_ui, self)


func _wire_events() -> void:
	EventBus.game_paused.connect(open_pause)
	EventBus.game_continued.connect(hide_pause)
	EventBus.new_day_started.connect(spawn_plant_on_new_day)
	EventBus.day_timer_tick.connect(day_counter_ui.set_day_counter_number)
	EventBus.attempts_updated.connect(attempts_ui.set_attempt_texture)
	EventBus.minigame_requested.connect(open_minigame)
	EventBus.game_over_won.connect(open_victory_screen)
	EventBus.game_over_lost.connect(open_lose_screen)
	EventBus.tooltip_show.connect(show_tooltip)
	EventBus.find_box_center_show.connect(open_find_box_center)
	EventBus.find_box_center_add_show.connect(open_find_box_center_add)
	EventBus.find_box_center_full_grow_show.connect(open_find_box_center_full_grow)
	EventBus.care_item_clear_requested.connect(care_box_ui.clear_current_care_box_item)
	EventBus.find_item_clear_requested.connect(find_box_ui.clear_current_find_box_item)
	EventBus.care_items_disable_requested.connect(care_box_ui.disable_input_for_items)
	EventBus.care_items_enable_requested.connect(care_box_ui.enable_input_for_items)
	EventBus.care_manual_open_requested.connect(open_care_manual)
	EventBus.find_manual_open_requested.connect(open_find_manual)
	EventBus.pause_ui_open_requested.connect(open_pause)


func settings_scene_open() -> void:
	hide_pause()


func spawn_plant_on_new_day(day_number: int, new_plant_scene: PlantTemplate) -> void:
	GlobalAudio.play_new_plant()
	EventBus.plant_registered.emit(new_plant_scene)
	plant_spawn_location.set_plant_on_first_enable(new_plant_scene)
	day_counter_ui.set_day_counter_text(day_number)


func open_day_switcher(current_day: int) -> void:
	var scene := day_switcher_ui.instantiate() as DaySwitcherUI
	scene.prepare_text(current_day)
	self.add_child(scene)

	care_manual.hide()
	find_manual.hide()
	find_box_circle_center.hide_circle()
	find_box_circle_center_add.hide_circle()
	info_tooltip_ui.hide_tooltip()
	care_box_ui.clear_current_care_box_item()
	find_box_ui.clear_current_find_box_item()


func open_minigame() -> void:
	var scene := game_over_mini_game_ui.instantiate() as GameOverMiniGameUI
	self.add_child(scene)


func open_victory_screen() -> void:
	var scene := victory_screen.instantiate() as VictoryScreen
	self.add_child(scene)


func open_lose_screen() -> void:
	var scene := lose_screen.instantiate() as LoseScreen
	self.add_child(scene)


func show_tooltip(text_in_tooltip: String) -> void:
	info_tooltip_ui.change_text(text_in_tooltip)
	info_tooltip_ui.show_tooltip()


func open_find_box_center(new_plant_texture: CompressedTexture2D, new_effect_texture: CompressedTexture2D) -> void:
	find_box_circle_center.show_circle(new_plant_texture, new_effect_texture)


func open_find_box_center_add(new_plant_template: PlantTemplate) -> void:
	find_box_circle_center_add.set_new_plant(new_plant_template)


func open_find_box_center_full_grow(new_plant_template: PlantTemplate) -> void:
	find_box_circle_center_add.set_plant_full_grow(new_plant_template)


func open_care_manual() -> void:
	care_manual.show()
	care_manual.open_start()


func open_find_manual() -> void:
	find_manual.show()
	find_manual.open_start()


func open_pause() -> void:
	pause_menu_ui.show()


func hide_pause() -> void:
	pause_menu_ui.hide()
