extends Area3D

@export var target: Node:
	set(v):
		target = v
		_power_receiver = null if not target else target if target is PowerReceiver else target.find_children("*", "PowerReceiver", false, false).get(0)

@export var active: bool = false:
	set(v):
		active = v
		if _power_receiver:
			_power_receiver.power.call_deferred(active)
		if save_state and Globals.player and Globals.player.status:
			Globals.player.status.level_node_states[get_path()] = active
		if animation_player:
			if active:
				animation_player.play("flip")
			else:
				animation_player.play_backwards("flip")

@export var save_state: bool = false

var _power_receiver: PowerReceiver

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _ready() -> void:
	if save_state and get_path() in Globals.player.status.level_node_states:
		active = Globals.player.status.level_node_states[get_path()]
	if _power_receiver:
		_power_receiver.power.call_deferred(active)

func interact() -> void:
	active = not active
	audio_stream_player_3d.play()
