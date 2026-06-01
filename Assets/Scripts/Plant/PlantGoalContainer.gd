extends HBoxContainer
class_name PlantGoalContainer

@export_group("Sprite")
@export var textures: Array[TextureRect]

@export_group("Texture")
@export var hollow_circle: CompressedTexture2D
@export var done_circle: CompressedTexture2D
@export var timer: Timer

var simple_tween: Tween


func show_all_circles(max_circles: int) -> void:
	for i in max_circles:
		textures[i].show()


func reset_all_circle() -> void:
	for texture in textures:
		texture.texture = hollow_circle


func set_done_circle(index: int) -> void:
	textures[index].texture = done_circle
	timer.start()


func _on_timer_timeout() -> void:
	if simple_tween:
		simple_tween.kill()

	# FIX: один Tween вместо N — используем .parallel() для каждой текстуры
	simple_tween = get_tree().create_tween()
	for texture in textures:
		simple_tween.parallel().tween_property(texture, "visible", false, 0.1)
