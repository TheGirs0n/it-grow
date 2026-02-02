extends Control
class_name FindBoxCircleCenter

@export var plant_texture : TextureRect
@export var effect_texture : TextureRect

var tween : Tween

func show_circle(new_plant_texture : CompressedTexture2D, new_effect_texture : CompressedTexture2D):
	self.show()
	plant_texture.texture = new_plant_texture
	effect_texture.texture = new_effect_texture
	
	self.mouse_filter = Control.MOUSE_FILTER_STOP
	
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 1, 0.4)
	
func hide_circle():
	if tween:
		tween.kill()
		
	tween = create_tween()
	tween.parallel().tween_property(self, "modulate:a", 0, 0.4)
	tween.tween_property(self, "visible", false, 0.3)
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				hide_circle()
