extends Node
class_name MainScene

## Composition Root — единственное место, знающее обо всех узлах.
## Удалён GlobalContext; GameManager и MainUI связываются здесь.

@export var game_manager: GameManager
@export var main_ui: MainUI


func _ready() -> void:
	main_ui.setup(game_manager)
	game_manager.setup(main_ui)
