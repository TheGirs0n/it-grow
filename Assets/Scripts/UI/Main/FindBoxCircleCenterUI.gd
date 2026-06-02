extends Control
class_name FindBoxCircleCenter

## FIX: modulate.a не сбрасывался перед анимацией появления
## Та же проблема, что была в FindBoxCircleCenterAdd и была исправлена там

@export var plant_texture: TextureRect
@export var effect_texture: TextureRect

var tween: Tween


func show_circle(new_plant_texture: CompressedTexture2D, new_effect_texture: CompressedTexture2D) -> void:
	show()
	plant_texture.texture = new_plant_texture
	effect_texture.texture = new_effect_texture
	mouse_filter = Control.MOUSE_FILTER_STOP

	if tween:
		tween.kill()

	# FIX: сбрасываем alpha перед анимацией — иначе при прерванном hide
	# появление начнётся с промежуточного значения
	modulate.a = 0.0

	tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.4)


func hide_circle() -> void:
	if tween:
		tween.kill()

	tween = create_tween()
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.4)
	tween.tween_property(self, "visible", false, 0.3)
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_gui_input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton):
		return
	if not (event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT):
		return
	if event.is_pressed():
		hide_circle()
