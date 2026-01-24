extends Control
class_name FindBoxUI

var current_find_box_item : FindBoxItem = null

func set_current_find_box_item(item : FindBoxItem) -> void:
	current_find_box_item = item
	
func clear_current_find_box_item():
	current_find_box_item.set_default_mouse_on_item()
	current_find_box_item = null
