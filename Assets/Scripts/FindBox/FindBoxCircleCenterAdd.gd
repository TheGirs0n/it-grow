extends Control
class_name FindBoxCircleCenterAdd

## Исправлено: modulate.a не сбрасывался перед анимацией появления
## → если предыдущий hide был прерван, show начинался с промежуточного значения

@export var plant_texture: TextureRect
@export var find_box_circle_ui: FindBoxCircleUI

var tween: Tween
var plant_template: PlantTemplate


func set_new_plant(new_plant_template: PlantTemplate) -> void:
	show_circle(new_plant_template, true)


func set_plant_full_grow(new_plant_template: PlantTemplate) -> void:
	show_circle(new_plant_template, false)


func show_circle(new_plant_template: PlantTemplate, visible_state: bool) -> void:
	find_box_circle_ui.visible = visible_state
	show()

	plant_template = new_plant_template
	plant_texture.texture = plant_template.plant_grow_stage_textures[plant_template.plant_care_stages_index]
	mouse_filter = Control.MOUSE_FILTER_STOP

	if tween:
		tween.kill()

	# FIX: сбрасываем alpha перед стартом анимации — иначе при прерванном hide
	# появление начнётся с промежуточного значения
	modulate.a = 0.0

	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.4)


func hide_circle() -> void:
	if tween:
		tween.kill()

	tween = get_tree().create_tween()
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.4)
	tween.tween_property(self, "visible", false, 0.0)

	mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_item_picked(item: FindBoxItem) -> void:
	plant_template.try_find_item(item)
	hide_circle()


func _on_gui_input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton):
		return
	if not (event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT):
		return
	if event.is_pressed():
		hide_circle()
