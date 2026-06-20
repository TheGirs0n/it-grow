extends Node2D
class_name PlantSpawnLocation

## Добавлен setup(main_ui) — вызывается из MainUI.setup()
## После добавления растения в дерево передаём ему ссылку на MainUI

@export var plant_location: Array[Marker2D]

var _main_ui: MainUI


func setup(main_ui: MainUI) -> void:
	_main_ui = main_ui


func set_plant_on_first_enable(plant_template: PlantTemplate) -> void:
	for spawn_point in plant_location:
		if spawn_point.get_child_count() == 0:
			spawn_point.add_child(plant_template)
			# Передаём MainUI растению после добавления в дерево
			plant_template.setup(_main_ui)
			return


## Текущее растение на грядке — нужно обучению для построения шагов гайда
func get_current_plant() -> PlantTemplate:
	for spawn_point in plant_location:
		for child in spawn_point.get_children():
			if child is PlantTemplate:
				return child
	return null
