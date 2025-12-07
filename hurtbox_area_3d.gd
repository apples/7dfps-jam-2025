extends Area3D
class_name HurtboxArea3D

@export var target_group: StringName = &"player"

var _hit_bodies: Array[Node3D]

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func clear() -> void:
	_hit_bodies.clear()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group(target_group):
		if body not in _hit_bodies:
			_hit_bodies.append(body)
			if body.has_method("hurt"):
				body.hurt()
