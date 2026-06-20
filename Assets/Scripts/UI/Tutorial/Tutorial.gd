extends Control
class_name Tutorial

## Переходный экран после кнопки «Начать игру»: запускает лор-сцену, которая ведёт в игру.
## Само обучение игрока — внутриигровой оверлей TutorialController (см. MainScene),
## показывается при первом запуске. Раньше set_lore_scene() нигде не вызывался,
## из-за чего Start упирался в пустой экран.

@export var lore_scene : PackedScene


func _ready() -> void:
	set_lore_scene()


func set_lore_scene():
	var scene = lore_scene.instantiate()
	get_tree().root.add_child(scene)
	self.queue_free()
