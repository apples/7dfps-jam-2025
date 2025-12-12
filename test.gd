extends Node3D

@export var level_scene: PackedScene

var level: Node3D

func _ready() -> void:
	Globals.menu_canvas_layer = $MenuCanvasLayer
	Globals.player.respawn_request.connect(_on_respawn_request)
	
	level = level_scene.instantiate()
	add_child(level)
	Globals.current_level_root = level
	
	var player_spawn_point := level.get_node_or_null("PlayerSpawnPoint") as Node3D
	if player_spawn_point:
		Globals.player.global_position = player_spawn_point.global_position
		Globals.player.HEAD.global_rotation.y = player_spawn_point.global_rotation.y
		Globals.player.status.respawn_point = player_spawn_point.global_position

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
