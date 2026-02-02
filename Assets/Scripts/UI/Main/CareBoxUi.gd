extends Control
class_name CareBoxUI

@onready var fertilizer_ui: Fertilizer = $FertilizerUi
@onready var watering_can_ui: WateringCan = $WateringCanUi
@onready var rake_ui: Rake = $RakeUi

var current_care_box_item : CareBoxItem = null

func set_current_care_box_item(item : CareBoxItem) -> void:
	if current_care_box_item == null:
		current_care_box_item = item
	else:
		current_care_box_item.set_default_mouse_on_item()
		current_care_box_item = item
		GlobalContext.main_ui_instance.find_box_ui.clear_current_find_box_item()
	
func clear_current_care_box_item():
	if current_care_box_item != null:
		current_care_box_item.set_default_mouse_on_item()
		current_care_box_item = null

func disable_input_for_items():
	fertilizer_ui.input_pickable = false
	watering_can_ui.input_pickable = false
	rake_ui.input_pickable = false
	
func enable_input_for_items():
	fertilizer_ui.input_pickable = true
	watering_can_ui.input_pickable = true
	rake_ui.input_pickable = true
