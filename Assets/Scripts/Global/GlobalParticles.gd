extends Node

@export var new_plant_grow_stage : PackedScene

func spawn_particles(parent_object : Node2D):
	var scene = new_plant_grow_stage.instantiate() as GPUParticles2D
	scene.finished.connect(func(): scene.queue_free())
	scene.emitting = true
	
	print("SPAWN" + scene.name)
	parent_object.add_child(scene)
