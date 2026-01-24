extends Control
class_name FindBoxCircleCenter

@export var plant_texture : TextureRect
@export var effect_texture : TextureRect
@export var timer : Timer

var tween : Tween

func show_circle(new_plant_texture : CompressedTexture2D, new_effect_texture : CompressedTexture2D):
	plant_texture.texture = new_plant_texture
	effect_texture.texture = new_effect_texture
	
	if tween:
		tween.kill()
		
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 1, 0.2)
	timer.start()
	
func hide_circle():
	if tween:
		tween.kill()
		
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.2)
