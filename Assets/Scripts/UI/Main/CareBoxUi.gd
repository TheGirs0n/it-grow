extends Control
class_name CareBoxUI

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
