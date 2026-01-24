extends Control
class_name FindBoxUI

@export var position_change : Vector2

var current_find_box_item : FindBoxItem = null
var is_open = false
var simple_tween : Tween

func set_current_find_box_item(item : FindBoxItem) -> void:
	current_find_box_item = item
	
func clear_current_find_box_item():
	current_find_box_item.set_default_mouse_on_item()
	current_find_box_item = null


func _on_button_pressed() -> void:
	print(is_open)
	print(global_position)
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
