extends Control
class_name FindBoxUI

@export var position_change : Vector2

var current_find_box_item : FindBoxItem = null
var is_open = false
var simple_tween : Tween

var mouse_entered_offset : Vector2 = Vector2(15, 0)
var original_position : Vector2

func _ready() -> void:
	original_position = position

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
		GlobalContext.main_ui_instance.care_box_ui.disable_input_for_items()
		GlobalContext.main_ui_instance.care_box_ui.clear_current_care_box_item()
	else:
		if simple_tween:
			simple_tween.kill()
			
		simple_tween = create_tween()
		simple_tween.tween_property(self, "global_position", global_position - position_change, 0.3)
		is_open = false
		GlobalContext.main_ui_instance.care_box_ui.enable_input_for_items()


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


func _on_move_box_mouse_entered() -> void:
	if is_open:
		return
	
	if simple_tween:
		simple_tween.kill()
		
	simple_tween = create_tween()
	simple_tween.set_trans(Tween.TRANS_QUAD)
	simple_tween.set_ease(Tween.EASE_OUT)
	simple_tween.tween_property(self, "position", original_position + mouse_entered_offset, 0.2)


func _on_move_box_mouse_exited() -> void:
	if is_open:
		return
	
	if simple_tween:
		simple_tween.kill()
		
	simple_tween = create_tween()
	simple_tween.set_trans(Tween.TRANS_QUAD)
	simple_tween.set_ease(Tween.EASE_OUT)
	simple_tween.tween_property(self, "position", original_position, 0.2)
