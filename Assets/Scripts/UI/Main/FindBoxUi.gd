extends Control
class_name FindBoxUI

@export var position_change : Vector2

var current_find_box_item : FindBoxItem = null
var is_open = false
var simple_tween : Tween

func set_current_find_box_item(item : FindBoxItem) -> void:
	if current_find_box_item == null:
		current_find_box_item = item
	else:
		current_find_box_item.set_default_mouse_on_item()
		current_find_box_item = item
		GlobalContext.main_ui_instance.care_box_ui.clear_current_care_box_item()
	
func clear_current_find_box_item():
	if current_find_box_item != null:
		current_find_box_item.set_default_mouse_on_item()
		current_find_box_item = null


func _on_button_pressed() -> void:
	if !is_open:
		if simple_tween:
			simple_tween.kill()
		
		simple_tween = create_tween()
		simple_tween.tween_property(self, "global_position", global_position + position_change, 0.3)
		is_open = true
	else:
		if simple_tween:
			simple_tween.kill()
			
		simple_tween = create_tween()
		simple_tween.tween_property(self, "global_position", global_position - position_change, 0.3)
		is_open = false


func _on_care_book_pressed() -> void:
	GlobalAudio.play_book_open()
	GlobalContext.main_ui_instance.open_care_manual()
	
	GlobalContext.main_ui_instance.care_box_ui.clear_current_care_box_item()
	GlobalContext.main_ui_instance.find_box_ui.clear_current_find_box_item()


func _on_find_book_pressed() -> void:
	GlobalAudio.play_book_open()
	GlobalContext.main_ui_instance.open_find_manual()
	
	GlobalContext.main_ui_instance.care_box_ui.clear_current_care_box_item()
	GlobalContext.main_ui_instance.find_box_ui.clear_current_find_box_item()
