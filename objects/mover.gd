extends PowerReceiver
class_name Mover

@export var distance: Vector3
@export var speed: float

var _initial: Vector3
var _target: Vector3

var _active: bool = false

func _ready() -> void:
	_initial = get_parent().global_position
	_target = _initial + distance
	power_on.connect(_on_power_on)
	power_off.connect(_on_power_off)

func _process(delta: float) -> void:
	var target := _target if _active else _initial
	var p := get_parent() as Node3D
	if not p.global_position.is_equal_approx(target):
		p.global_position = p.global_position.move_toward(target, speed * delta)

func _on_power_on() -> void:
	_active = true

func _on_power_off() -> void:
	_active = false
