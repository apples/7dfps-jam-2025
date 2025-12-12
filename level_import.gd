@tool
extends EditorScenePostImport

func _post_import(scene):
	iterate(scene)
	return scene

func iterate(node):
	if not node:
		return
	if node is StaticBody3D:
		if node.get_parent().name.begins_with("Lava"):
			var area := load("uid://ctnpx82800rjk").new() as Area3D
			area.name = "LavaArea"
			area.transform = node.transform
			area.collision_layer = node.collision_layer
			area.collision_mask = node.collision_mask
			area.collision_priority = node.collision_priority
			node.replace_by(area, true)
			node.free()
			node = area
	for child in node.get_children():
		iterate(child)
