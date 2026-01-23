extends CanvasLayer
class_name MainUI

@export var care_box_ui : CareBoxUI
@export var pause_menu_ui : PauseMenuUI

func _ready() -> void:
	GlobalContext.main_ui_instance = self
	
func _exit_tree() -> void:
	GlobalContext.main_ui_instance = null

func settings_scene_open():
	hide_pause()

func open_pause():
	pause_menu_ui.show()
	
func hide_pause():
	pause_menu_ui.hide()
