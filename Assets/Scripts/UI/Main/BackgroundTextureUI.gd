extends TextureRect
class_name BackgroundTextureUI
 
 
func _on_gui_input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton):
		return
	if event.button_index != MOUSE_BUTTON_RIGHT or not event.is_pressed():
		return
 
	# FIX: убран GlobalContext → EventBus
	# MainUI уже подписан на эти сигналы и вызывает clear на нужных компонентах
	EventBus.find_item_clear_requested.emit()
	EventBus.care_item_clear_requested.emit()
 
