extends Interactable

const FOUNTAIN_MENU = preload("uid://c300aabr13gdi")

func interact():
	assert(Globals.menu_canvas_layer)
	var menu = FOUNTAIN_MENU.instantiate()
	Globals.menu_canvas_layer.add_child(menu)
