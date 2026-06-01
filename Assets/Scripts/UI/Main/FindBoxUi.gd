extends Control
class_name FindBoxUI

## Убран GlobalContext — зависимости передаются через setup() из MainUI

@export var position_change: Vector2

var current_find_box_item: FindBoxItem = null
var is_open: bool = false
var simple_tween: Tween

var mouse_entered_offset: Vector2 = Vector2(15, 0)
var original_position: Vector2

var _care_box_ui: CareBoxUI
var _main_ui: MainUI


func _ready() -> void:
	original_position = position


func setup(care_box_ui: CareBoxUI, main_ui: MainUI) -> void:
	_care_box_ui = care_box_ui
	_main_ui = main_ui


func set_current_find_box_item(item: FindBoxItem) -> void:
	if current_find_box_item == null:
		current_find_box_item = item
	else:
		current_find_box_item.set_default_mouse_on_item()
		current_find_box_item = item
		_care_box_ui.clear_current_care_box_item()


func clear_current_find_box_item() -> void:
	if current_find_box_item != null:
		current_find_box_item.set_default_mouse_on_item()
		current_find_box_item = null


func _on_button_pressed() -> void:
	if not is_open:
		if simple_tween:
			simple_tween.kill()
		simple_tween = create_tween()
		simple_tween.tween_property(self, "global_position", global_position + position_change, 0.3)
		is_open = true
		_care_box_ui.disable_input_for_items()
		_care_box_ui.clear_current_care_box_item()
	else:
		if simple_tween:
			simple_tween.kill()
		simple_tween = create_tween()
		simple_tween.tween_property(self, "global_position", global_position - position_change, 0.3)
		is_open = false
		_care_box_ui.enable_input_for_items()


func _on_care_book_pressed() -> void:
	GlobalAudio.play_book_open()
	EventBus.care_manual_open_requested.emit()
	EventBus.care_item_clear_requested.emit()
	EventBus.find_item_clear_requested.emit()


func _on_find_book_pressed() -> void:
	GlobalAudio.play_book_open()
	EventBus.find_manual_open_requested.emit()
	EventBus.care_item_clear_requested.emit()
	EventBus.find_item_clear_requested.emit()


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
