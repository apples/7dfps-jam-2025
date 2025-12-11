extends Area3D

const FAN_ROTATION_SPEED = 2.0 * TAU

@export var wind_speed: float = 30.0
#@export var length: float = 2.0:
	#set(v):
		#

var fan_rotation: float

@onready var skeleton_3d: Skeleton3D = $fan2/Armature/Skeleton3D
@onready var fan_bone: int = skeleton_3d.find_bone("fan")
@onready var fan_bone_base_rotation: Quaternion = skeleton_3d.get_bone_pose_rotation(fan_bone)
@onready var wind_end_bone: int = skeleton_3d.find_bone("windEnd")

func _process(delta: float) -> void:
	fan_rotation += delta * FAN_ROTATION_SPEED
	var rot = Quaternion(Vector3(1, 0, 0), -fan_rotation) * fan_bone_base_rotation
	skeleton_3d.set_bone_pose_rotation(fan_bone, rot)
	
	print(skeleton_3d.get_bone_global_pose(wind_end_bone).origin)
	
	for body in get_overlapping_bodies():
		if "wind_velocity" in body:
			body.wind_velocity += global_basis.z * wind_speed
