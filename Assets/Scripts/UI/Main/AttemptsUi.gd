extends Control
class_name AttemptsUI

@export_group("Texture")
@export var texture_rect: TextureRect

@export_group("Compressed Textures")
@export var attempts_textures: Array[CompressedTexture2D]


func set_attempt_texture(current_attempts: int) -> void:
	# FIX: нет гарантии что current_attempts в пределах массива → clampi защищает от краша
	var idx := clampi(current_attempts, 0, attempts_textures.size() - 1)
	texture_rect.texture = attempts_textures[idx]
