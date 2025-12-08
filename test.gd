extends Node3D

func _ready() -> void:
	Globals.current_level_root = $level1
	Globals.menu_canvas_layer = $MenuCanvasLayer
