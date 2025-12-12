extends Node3D
class_name Spinner

@export var angular_speed: float = TAU
@export_enum("x","y","z") var axis: String = "y"

func _process(delta: float) -> void:
	rotation[axis] += angular_speed * delta
