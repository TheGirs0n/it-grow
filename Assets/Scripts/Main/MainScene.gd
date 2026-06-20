extends Node
class_name MainScene

## Composition Root — единственное место, знающее обо всех узлах.
## Удалён GlobalContext; GameManager и MainUI связываются здесь.

const TutorialControllerScene := preload("res://Assets/Scripts/UI/Tutorial/TutorialController.gd")

@export var game_manager: GameManager
@export var main_ui: MainUI


func _ready() -> void:
	# Обучение показывается только при первом запуске (флаг хранится в settings.cfg)
	var run_tutorial: bool = not SettingManager.is_tutorial_completed()
	game_manager.tutorial_mode = run_tutorial

	main_ui.setup(game_manager)
	# setup() запускает first_entry() → спавнит первое растение
	game_manager.setup(main_ui)

	if run_tutorial:
		_start_tutorial()


func _start_tutorial() -> void:
	var tutorial := TutorialControllerScene.new()
	add_child(tutorial)
	tutorial.begin(main_ui)
