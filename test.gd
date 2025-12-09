extends Node3D

@export var level_scene: PackedScene = preload("uid://dr4n2p5sy4dwt")

var level: Node3D

func _ready() -> void:
	Globals.menu_canvas_layer = $MenuCanvasLayer
	Globals.player.respawn_request.connect(_on_respawn_request)
	
	level = level_scene.instantiate()
	add_child(level)
	Globals.current_level_root = level

func _on_respawn_request() -> void:
	level.queue_free()
	remove_child(level)
	Globals.current_level_root = null
	level = null
	
	Globals.player.global_position = Globals.player.status.respawn_point
	Globals.player.rest()
	
	level = level_scene.instantiate()
	add_child(level)
	Globals.current_level_root = level
