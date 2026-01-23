extends Node

@export var plant_resources : Array[PlantResource]

func get_random_plant_resource() -> PlantResource:
	return plant_resources.pick_random()
