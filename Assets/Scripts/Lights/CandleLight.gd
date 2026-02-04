extends PointLight2D
class_name CandleLight

@export_group("Energy Parameters")
@export var min_energy : float
@export var max_energy : float

@export_group("Texture Scale Parameters")
@export var min_texture_scale : float
@export var max_texture_scale : float

@export_group("Position Parameters")
@export var min_position_offset : Vector2
@export var max_position_offset : Vector2

@export_group("Timer")
@export var timer : Timer

var original_position : Vector2

var tween : Tween

func _ready() -> void:
	original_position = position

func switch_light_parameters() -> void:
	var new_position_x = original_position.x + randf_range(min_position_offset.x, max_position_offset.x)
	var new_position_y = original_position.y + randf_range(min_position_offset.y, max_position_offset.y)
	
	var new_energy = randf_range(min_energy, max_energy)
	var new_texture_scale = randf_range(min_texture_scale, max_texture_scale)
	var new_position = Vector2(new_position_x, new_position_y)
	
	if tween:
		tween.kill()
		
	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.set_parallel().tween_property(self, "energy", new_energy, timer.wait_time)
	tween.set_parallel().tween_property(self, "texture_scale", new_texture_scale, timer.wait_time)
	tween.set_parallel().tween_property(self, "position", new_position, timer.wait_time)
