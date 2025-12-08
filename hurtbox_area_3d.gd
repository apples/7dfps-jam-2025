extends Area3D
class_name HurtboxArea3D

@export var target_group: StringName = &"player"

## If -1, treat as unlimited.
@export var max_hit: int = 1

var _hit_bodies: Array[Node3D]
var _last_hit: int = 0
var _hit_queued: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func clear() -> void:
	_hit_bodies.clear()
	_last_hit = 0

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group(target_group):
		if body not in _hit_bodies and body.has_method("hurt"):
			_hit_bodies.append(body)
			if not _hit_queued:
				_hit_queued = true
				_hurt_bodies.call_deferred()

func _hurt_bodies() -> void:
	_hit_queued = false
	if _last_hit >= max_hit:
		_last_hit = _hit_bodies.size()
		return
	var to_hit = _hit_bodies.slice(_last_hit)
	_hit_bodies.resize(_last_hit)
	to_hit.sort_custom(func (a, b):
		return a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position))
	_hit_bodies.append_array(to_hit)
	var n = _hit_bodies.size()
	for i in range(_last_hit, mini(n, max_hit)):
		_hit_bodies[i].hurt()
	_last_hit = n
