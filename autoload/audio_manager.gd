extends Node

var _sfx_players: Array[AudioStreamPlayer]
var _sfx_players_3d: Array[AudioStreamPlayer3D]

func play_sfx(stream: AudioStream) -> void:
	var player: AudioStreamPlayer
	for p in _sfx_players:
		if not p.playing:
			player = p
			break
	if not player:
		player = AudioStreamPlayer.new()
		player.bus = "SFX"
		_sfx_players.append(player)
		add_child(player)
	player.stream = stream
	player.play()

func play_sfx_3d(stream: AudioStream, global_position: Vector3) -> void:
	var player: AudioStreamPlayer3D
	for p in _sfx_players_3d:
		if not p.playing:
			player = p
			break
	if not player:
		player = AudioStreamPlayer3D.new()
		player.bus = "SFX"
		_sfx_players_3d.append(player)
		add_child(player)
	player.global_position = global_position
	player.stream = stream
	player.play()
