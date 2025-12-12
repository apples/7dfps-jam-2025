extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_power_receiver_power_off() -> void:
	animation_player.play_backwards("open")

func _on_power_receiver_power_on() -> void:
	animation_player.play("open")
