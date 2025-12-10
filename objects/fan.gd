extends Area3D

const FAN_ROTATION_SPEED = 2.0 * TAU

var fan_rotation: float

@onready var skeleton_3d: Skeleton3D = $fan2/Armature/Skeleton3D
@onready var fan_bone: int = skeleton_3d.find_bone("fan")
@onready var fan_bone_base_rotation: Quaternion = skeleton_3d.get_bone_pose_rotation(fan_bone)

func _process(delta: float) -> void:
	fan_rotation += delta * FAN_ROTATION_SPEED
	var rot = Quaternion(Vector3(1, 0, 0), -fan_rotation) * fan_bone_base_rotation
	skeleton_3d.set_bone_pose_rotation(fan_bone, rot)

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_TRANSFORM_CHANGED:
			gravity_direction = global_basis.z
