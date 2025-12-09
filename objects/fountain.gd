extends Interactable

const FOUNTAIN_MENU = preload("uid://c300aabr13gdi")

var player_in_range: bool = false

@onready var spot_light_3d: SpotLight3D = $SpotLight3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(_delta: float) -> void:
	if Globals.player:
		var pdist := Globals.player.global_position.distance_to(global_position)
		spot_light_3d.light_energy = clampf(pdist, 0.5, 2.0)
		if pdist <= 4.0 and not player_in_range:
			player_in_range = true
			animation_player.play("drop")
		elif pdist > 4.0 and player_in_range:
			player_in_range = false
			animation_player.play_backwards("drop")

func interact():
	assert(Globals.menu_canvas_layer)
	Globals.player.status.respawn_point = $RespawnMarker.global_position
	var menu = FOUNTAIN_MENU.instantiate()
	Globals.menu_canvas_layer.add_child(menu)
