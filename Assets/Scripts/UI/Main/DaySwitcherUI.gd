extends Control
class_name DaySwitcherUI

@export_group("Day Texts")
@export var current_day_text : RichTextLabel
@export var next_day_text : RichTextLabel

func prepare_text(current_day : int):
	current_day_text.text = str(current_day - 1)
	next_day_text.text = str(current_day)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "new_animation":
		queue_free()


func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == "new_animation":
		GlobalContext.game_manager_instance.new_day_parameters()
