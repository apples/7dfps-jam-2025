extends Node

var _sfx_players: Array[AudioStreamPlayer]

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
