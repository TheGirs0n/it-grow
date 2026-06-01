extends Control
class_name LoreMoment

## Исправлено: каст main_scene.instantiate() as GameManager → as MainScene
## GameManager — дочерний узел, а не корень сцены; каст давал null → игра не запускалась

@export var main_scene: PackedScene
@export var animation_player: AnimationPlayer

var is_text_full_appeared: bool = false


func _on_gui_input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton):
		return
	if not (event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT):
		return
	if event.is_pressed():
		try_close_lore_entrance()


func try_close_lore_entrance() -> void:
	if not is_text_full_appeared:
		var length := animation_player.current_animation_length
		animation_player.advance(length)
	else:
		# FIX: был "as GameManager" — GameManager не является корнем сцены,
		# каст возвращал null и get_tree().root.add_child(null) крашил игру
		var scene := main_scene.instantiate() as MainScene
		get_tree().root.add_child(scene)
		queue_free()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "text_appear":
		is_text_full_appeared = true
