extends Interactable

const FOUNTAIN_MENU = preload("uid://c300aabr13gdi")

func interact():
	assert(Globals.menu_canvas_layer)
	get_tree().paused = true
	var menu = FOUNTAIN_MENU.instantiate()
	Globals.menu_canvas_layer.add_child(menu)
	await menu.tree_exited
	if get_tree():
		get_tree().paused = false
