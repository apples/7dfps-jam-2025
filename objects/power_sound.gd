extends AudioStreamPlayer3D

func _on_power_receiver_power_off() -> void:
	stop()

func _on_power_receiver_power_on() -> void:
	play()
