extends Control
class_name AttemptsUI

@export_group("Texture")
@export var texture_rect : TextureRect

@export_group("Compressed Textures")
@export var attempts_textures : Array[CompressedTexture2D]

func set_attempt_texture(current_attempts : int):
	texture_rect.texture = attempts_textures[current_attempts]
