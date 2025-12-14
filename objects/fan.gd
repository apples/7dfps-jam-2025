@tool
extends Area3D

const FAN_ROTATION_SPEED = 2.0 * TAU

@export var wind_speed: float = 30.0
@export var length: float = 2.0:
	set(v):
		length = v
		_update_state()
@export var attenuation: float = 0.0
@export var active_when_powered: bool = false

var fan_rotation: float

var powered: bool = false:
	set(v):
		powered = v
		_update_state()

@onready var skeleton_3d: Skeleton3D = $fan2/Armature/Skeleton3D
@onready var fan_bone: int = skeleton_3d.find_bone("fan")
@onready var fan_bone_base_rotation: Quaternion = skeleton_3d.get_bone_pose_rotation(fan_bone)
@onready var wind_end_bone: int = skeleton_3d.find_bone("windEnd")
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var shape_cast_3d: ShapeCast3D = $ShapeCast3D

@onready var audio_stream_players: Array[AudioStreamPlayer3D] = [
	$AudioStreamPlayer3D,
	$AudioStreamPlayer3D2,
]

func _ready() -> void:
	_update_state()

func _process(delta: float) -> void:
	_update_state()
	
	var active := active_when_powered == powered
	if not active:
		return
	
	fan_rotation += delta * FAN_ROTATION_SPEED
	var rot = Quaternion(Vector3(1, 0, 0), -fan_rotation) * fan_bone_base_rotation
	skeleton_3d.set_bone_pose_rotation(fan_bone, rot)
	
	for body in get_overlapping_bodies():
		if "wind_velocity" in body:
			var wind_vel := global_basis.z * wind_speed
			var d := body.global_position - global_position
			d = d.project(global_basis.z)
			var df := 1.0 - clampf(d.length() / length, 0.0, 1.0)
			body.wind_velocity += global_basis.z * wind_speed * pow(df, attenuation)

func _update_state() -> void:
	if not is_inside_tree():
		return
	
	var active := active_when_powered == powered
	
	shape_cast_3d.target_position.z = length - 0.5
	
	var actual_length := length
	
	if active:
		shape_cast_3d.force_shapecast_update()
		if shape_cast_3d.is_colliding():
			actual_length *= shape_cast_3d.get_closest_collision_safe_fraction()
	
	var wind_end_pose := skeleton_3d.get_bone_global_rest(wind_end_bone)
	wind_end_pose.origin.z = actual_length if active else 0.0
	skeleton_3d.set_bone_global_pose(wind_end_bone, wind_end_pose)
	
	collision_shape_3d.shape.height = actual_length
	collision_shape_3d.position.z = actual_length / 2.0
	collision_shape_3d.disabled = not active
	
	for asp in audio_stream_players:
		if active and not asp.playing:
			asp.play()
		elif not active and asp.playing:
			asp.stop()

func _on_power_receiver_power_off() -> void:
	powered = false
	_update_state()

func _on_power_receiver_power_on() -> void:
	powered = true
	_update_state()
