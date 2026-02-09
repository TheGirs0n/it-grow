extends Control
class_name Tutorial

@export var lore_scene : PackedScene

func set_lore_scene():
	var scene = lore_scene.instantiate()
	get_tree().root.add_child(scene)
	self.queue_free()
