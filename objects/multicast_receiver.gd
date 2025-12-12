extends PowerReceiver
class_name MulticastReceiver

@export var targets: Array[Node]

func _ready() -> void:
	power_on.connect(_on_power_on)
	power_off.connect(_on_power_off)

func _on_power_on() -> void:
	for target in targets:
		var power_receiver = target if target is PowerReceiver else target.find_children("*", "PowerReceiver", false, false).get(0)
		power_receiver.power(true)

func _on_power_off() -> void:
	for target in targets:
		var power_receiver = target if target is PowerReceiver else target.find_children("*", "PowerReceiver", false, false).get(0)
		power_receiver.power(false)
