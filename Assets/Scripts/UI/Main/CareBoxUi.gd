extends Control
class_name CareBoxUI

var current_care_box_item : CareBoxItem = null

func set_current_care_box_item(item : CareBoxItem) -> void:
	current_care_box_item = item
	
func clear_current_care_box_item():
	current_care_box_item = null
