extends HBoxContainer
class_name PlantGoalContainer

@export_group("Sprite")
@export var textures : Array[TextureRect]

@export_group("Texture")
@export var hollow_circle : CompressedTexture2D
@export var done_circle : CompressedTexture2D

func show_all_circles(max_circles : int):
	for i in max_circles:
		textures[i].show()

func reset_all_circle():
	for texture in textures:
		texture.texture = hollow_circle
		
func set_done_circle(index : int):
	textures[index].texture = done_circle
