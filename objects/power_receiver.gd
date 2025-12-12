extends Node
class_name PowerReceiver

signal power_on()
signal power_off()

var active: bool = false

func _ready() -> void:
	if active:
		power_on.emit()

func power(p_active: bool) -> void:
	if not active and p_active:
		active = p_active
		power_on.emit()
	elif active and not p_active:
		active = p_active
		power_off.emit()
