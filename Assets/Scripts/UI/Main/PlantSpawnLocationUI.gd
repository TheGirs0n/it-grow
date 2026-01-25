extends Node2D
class_name PlantSpawnLocation

@export var plant_location : Array[Marker2D]

func set_plant_on_first_enable(plant_template : PlantTemplate):
	for spawn_point in plant_location:
		if spawn_point.get_child_count() == 0:
			spawn_point.add_child(plant_template)
			print(spawn_point.name + "spawn" + str(plant_template.global_position))
			return
