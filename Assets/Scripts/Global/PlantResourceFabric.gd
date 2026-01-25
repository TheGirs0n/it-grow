extends Node

@export var plant_resources : Array[PackedScene]

func get_random_plant_resource() -> PlantTemplate:
	var scene = plant_resources.pick_random().instantiate() as PlantTemplate
	return scene

func get_first() -> PlantTemplate:
	var scene = plant_resources[0].instantiate() as PlantTemplate
	return scene
