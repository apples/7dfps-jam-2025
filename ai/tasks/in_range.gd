@tool
extends BTCondition

@export var target_range: float = 2.0
@export var vision_angle: float = 180.0
@export var target_var: StringName = &"target"

func _generate_name() -> String:
	if vision_angle == 180.0:
		return "In Range %s of %s" % [target_range, target_var]
	else:
		return "In Range %s of %s (%s degrees)" % [target_range, target_var, vision_angle]

func _tick(_delta: float) -> Status:
	var target := blackboard.get_var(target_var, null) as Node3D
	if not target:
		return FAILURE
	var c_agent = self.agent as Node3D
	if c_agent.global_basis.z.angle_to(c_agent.global_position.direction_to(target.global_position)) > deg_to_rad(vision_angle):
		return FAILURE
	if c_agent.global_position.distance_to(target.global_position) > target_range:
		return FAILURE
	return SUCCESS
