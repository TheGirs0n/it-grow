extends Node

@export var plant_resources : Array[PackedScene]
var plant_unique_resources : Array[PackedScene]

func _ready() -> void:
	reset_fabric()

func reset_fabric():
	plant_unique_resources = plant_resources.duplicate()
	

func get_random_plant_resource() -> PlantTemplate:
	var random_index = randi() % plant_unique_resources.size()
	var scene = plant_unique_resources.pop_at(random_index)
	
	return scene.instantiate() as PlantTemplate

func get_first() -> PlantTemplate:
	var scene = plant_unique_resources[0].instantiate() as PlantTemplate
	plant_unique_resources.remove_at(0)
	plant_unique_resources.shuffle()
	
	return scene
