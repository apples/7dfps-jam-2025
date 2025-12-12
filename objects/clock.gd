extends Node
class_name Clock

@export var target: Node:
	set(v):
		target = v
		_power_receiver = target if target is PowerReceiver else target.find_children("*", "PowerReceiver", false, false).get(0)

@export var time_off: float = 1.0
@export var time_on: float = 1.0
@export var start_time: float = 0.0

var _power_receiver: PowerReceiver

var _time: float
var _active: bool = false

func _ready() -> void:
	_time = start_time
	_active = fposmod(_time, time_on + time_off) > time_off
	if _power_receiver:
		_power_receiver.power.call_deferred(_active)

func _process(delta: float) -> void:
	_time += delta
	_update_active()

func _update_active() -> void:
	var is_active := fposmod(_time, time_on + time_off) > time_off
	if _active != is_active:
		_active = is_active
		if _power_receiver:
			_power_receiver.power.call_deferred(_active)
