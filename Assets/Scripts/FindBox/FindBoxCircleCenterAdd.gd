extends Control
class_name FindBoxCircleCenterAdd

@export var plant_texture : TextureRect

var tween : Tween
var plant_template : PlantTemplate

func set_new_plant(new_plant_template : PlantTemplate):
	self.show()
	plant_template = new_plant_template
	plant_texture.texture = plant_template.plant_grow_stage_textures[plant_template.plant_care_stages_index]
	
	self.mouse_filter = Control.MOUSE_FILTER_STOP
	
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, 0.4)

func hide_circle():
	tween = get_tree().create_tween()
	tween.parallel().tween_property(self, "modulate:a", 0, 0.4)
	tween.tween_property(self, "visible", false, 0.4)
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_item_picked(item: FindBoxItem) -> void:
	plant_template.try_find_item(item)
	hide_circle()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				hide_circle()
