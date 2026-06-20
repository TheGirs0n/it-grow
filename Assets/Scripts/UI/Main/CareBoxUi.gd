extends Control
class_name CareBoxUI

## Убран GlobalContext — прямая ссылка на FindBoxUI передаётся через setup()
## из MainUI, которая знает оба узла

@onready var fertilizer_ui: Fertilizer = $FertilizerUi
@onready var watering_can_ui: WateringCan = $WateringCanUi
@onready var rake_ui: Rake = $RakeUi

var current_care_box_item: CareBoxItem = null

var _find_box_ui: FindBoxUI


func setup(find_box_ui: FindBoxUI) -> void:
	_find_box_ui = find_box_ui


func set_current_care_box_item(item: CareBoxItem) -> void:
	if current_care_box_item == null:
		current_care_box_item = item
	else:
		current_care_box_item.set_default_mouse_on_item()
		current_care_box_item = item
		_find_box_ui.clear_current_find_box_item()


func clear_current_care_box_item() -> void:
	if current_care_box_item != null:
		current_care_box_item.set_default_mouse_on_item()
		current_care_box_item = null


func disable_input_for_items() -> void:
	fertilizer_ui.input_pickable = false
	watering_can_ui.input_pickable = false
	rake_ui.input_pickable = false


func enable_input_for_items() -> void:
	fertilizer_ui.input_pickable = true
	watering_can_ui.input_pickable = true
	rake_ui.input_pickable = true


# --- Хелперы для обучения ---

## Оставляет кликабельным только инструмент нужного типа (для гайда по уходу)
func set_only_enabled(care_type: GlobalEnums.PLANT_CARE_TYPE) -> void:
	fertilizer_ui.input_pickable = care_type == GlobalEnums.PLANT_CARE_TYPE.FERTILIZER
	watering_can_ui.input_pickable = care_type == GlobalEnums.PLANT_CARE_TYPE.WATERING_CAN
	rake_ui.input_pickable = care_type == GlobalEnums.PLANT_CARE_TYPE.RAKE


## Экранная позиция инструмента — обучение наводит на неё стрелку-подсказку
func get_item_screen_position(care_type: GlobalEnums.PLANT_CARE_TYPE) -> Vector2:
	var item: Node2D
	match care_type:
		GlobalEnums.PLANT_CARE_TYPE.FERTILIZER:
			item = fertilizer_ui
		GlobalEnums.PLANT_CARE_TYPE.RAKE:
			item = rake_ui
		GlobalEnums.PLANT_CARE_TYPE.WATERING_CAN:
			item = watering_can_ui
	return item.get_global_transform_with_canvas().origin
