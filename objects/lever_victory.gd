extends "res://lever.gd"
const WIN_SCREEN = preload("uid://cuxodgymqwjpq")

func interact() -> void:
	var menu = WIN_SCREEN.instantiate()
	audio_stream_player_3d.play()
	Globals.menu_canvas_layer.add_child(menu)
